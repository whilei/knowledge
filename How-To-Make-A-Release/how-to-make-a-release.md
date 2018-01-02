# How to Make a Release

0. Begin [the soundtrack](https://www.youtube.com/watch?v=5qowkuqH9lE).

1. Tag a commit and push the tag.

```shell
# I like to use relevant news headlines from hacker news for the messages for 'planned' releases,
# and descriptive messages for bugfix releases.
git tag -a v1.2.3 -m "Physicists Uncover Geometric ‘Theory Space'"

# Push the tag upstream. This should trigger a new CI build.
git push upstream v1.2.3
```

> There used to be an annoying thing where the CI would only build on `branch=master`, in which case if you wanted the proper build name (from the tag) and had pushed the tag _after_ pushing/creating the merge commit on Github, you had to restart the CIs to get them to use proper tag in the build archive names. Or, you could create the commit/merge locally, then push the tag _before_ pushing the commit.

```shell
git checkout master
git merge -S feat/thingey
git tag -a v1.2.3 -m "Fixed it all."
git push upstream v1.2.3
git push upstream master
```

But if you use a kind-of-hacky config for Travis/AppVeyor you won't have to worry about it, and
can push the tag whenever you want.

```yaml
# Deploy on either branch=master or tags=true. Identical process, different conditions.
# https://github.com/travis-ci/travis-ci/issues/7780#issuecomment-302389370
deploy:
  - provider: script
    skip_cleanup: true
    script: ./deploy.sh
    on:
      branch: master
  - provider: script
    skip_cleanup: true
    script: ./deploy.sh
    on:
      tags: true
```


2. ... Wait for the CI builds to finish.

3. 3 years later, visit http://builds.etcdevteam.com and download the relevant builds.

4. Verify the builds are right and everything looks in order.

5. Sign all the builds. I use the script below to save some time.

```shell
#!/usr/bin/env bash

# Signs all globbed arguments with gpg2.
# Creates both binary and ascii versions and verifies each signature.

for f in $*; do
    echo "------------------------------------------"
    echo "Signing (.sig) $f"
    gpg --detach-sign "$f"

    echo "Signing (.asc) $f"
    gpg --detach-sign --armor "$f"

    echo "Verifying $f.sig"
    gpg --verify "$f.sig"

    echo "Verifying $f.asc"
    gpg --verify "$f.asc"
    echo "------------------------------------------"
done

```

6. Draft a new release on Github. See below for a standard template you can use if you have writer's block for the release notes.

7. Upload the builds and signatures.

8. Push the green button.

9. If your project is on [homebrew-classic](https://github.com/ethereumproject/homebrew-classic), increment the version there too!

```shell
```


----

# Notes, standards, and references

## Tagging

> v.W.T.F+3117-f00849

Use [semver](http://semver.org/) ... most release tags should be on minor, major, or patch version increments. Patch version increment number do not correspond to the literal number of commits since the last release tag, but are `+1` from the patch number of the last tagged release. Otherwise it confuses people.

## Including Artifacts

When possible, include builds for all three major OS's:

1. Linux
2. OSX
3. Windows

There's a lot of different kind of _architectures_. This is tricky. Hmm.... help?

Typically we include solely `.zip` for Windows, and include both `.zip` and `.tar.gz` for OSX and Linux.

Sign each release artifact. Caveat: a signature is only as strong as the ones next to it. TODO: More on using `gpg` FTW and maybe even begin/continue some thinking about how to devise a more trustful/trustless team/+community signatures system (eg. Gitian?)

## Writing Release Notes

You can (re)use standard [CHANGELOG format](http://keepachangelog.com/) to outline relevant changes since the last release. Here, I've add a `consensus` header to supplement the standard categories because... yea, I just did. It makes sense to me.

    #### Consensus
    - [ECIP-1017](https://github.com/ethereumproject/ECIPs/blob/master/ECIPs/ECIP-1017.md) - implement monetary policy for Morden Testnet (2 million block era) and Mainnet (5 million block era). If you're using geth, _please update_!

    #### Added
    - JSON-RPC: `debug_traceTransaction` method
    - JSON-RPC: `eth_chainId` method; returns configured Ethereum EIP-155 chain id for signing protected txs. For congruent behavior in Ethereum Foundation and Parity clients, please see https://github.com/ethereum/EIPs/pull/695 and https://github.com/paritytech/parity/pull/6329.
    - P2P: improve peer discovery by allowing "good-will" for peers with unknown HF blocks
    - _Option_: `—log-status` - enable interval-based status logging, e.g. `—log-status="sync=10"`, where `sync` is the context (currently the only one implemented) and `10` is interval in seconds.

    #### Fixed
    - geth/cmd: Improve chain configuration file handling to allow specifying a file instead
     of chain identity and allow flag overrides for bootnodes and network-id.
    - _Command_: `monitor` - enables sexy terminal-based graphs for metrics around
     a specified set of modules, e.g.

     ```
     $ geth
     ```

     ```
     $ geth monitor "p2p/.*/(count|average)" "msg/txn/out/.*/count"
     ```

    - P2P: Improve wording for logging as-yet-unknown nodes.

    ----

I like to give a shout-out to contributors, big and small.


    #### Contributors
    - @whilei
    - @sorpaas
    - @tzdybal
    - @splix

    ----

TL;DR about what the heck `.sig` and `.asc` files even are, and how to use them.

... It would be nice if there were a way to standardize and de-personalize the assurance of the signature (ie remove the "Isaac"-specific parts of the below).


     `.zip.sig` and `.tar.gz.sig` files are detached PGP signatures
     `.zip.asc` and `.tar.gz.asc` files are _ascii-armored_ detached PGP signatures
     `.zip` and `.tar.gz` are archive (compressed) files containing the `geth` executable

    __To verify a release with a signature:__ First, make sure you have a `gpg` tool installed, eg. `gnupg` or `gnupg2`. Then, if you haven't already, you'll need to import the signing key, which you'll find [here](https://raw.githubusercontent.com/ethereumproject/volunteer/master/Volunteer-Public-Keys/isaac.ardis%40gmail.com). This step is included below.

    ```shell
    # Import my signing public key
    $ wget https://raw.githubusercontent.com/ethereumproject/volunteer/master/Volunteer-Public-Keys/isaac.ardis%40gmail.com
    $ gpg —import isaac.ardis@gmail.com
    # Verify
    $ gpg -verify geth-classic-win64-v3.5.0+86-db60074e.zip.sig geth-classic-win64-v3.5.0+86-db60074e.zip
    gpg: Signature made Wed Jul 19 13:29:32 2017 CDT using RSA key ID 7419D94C
    gpg: Good signature from "Isaac Ardis (ETCDEV Go Developer) <isaac.ardis@gmail.com>" [ultimate]
    ```


Finally, a note about where the artifacts came from (and where to find more).

    All tagged and development downloads are also be available at our automated builds website: http://builds.etcdevteam.com.
