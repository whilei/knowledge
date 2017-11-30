# Engineering Guidelines

Style guidelines and best practices for our engineering team.

# Commit Message Structure

---

We use `Problem/Solution` commit structure.

 `Problem` - the reason to introduce the change

 `Solution` - how you solved it

Don't forget the reason why we add commit message. Commit messages are helpful when someone else, or maybe you but a year later, will dig trough code changes and will need to understand why this particular change was made. And usually you have two parts to describe, a reason why you decided to make a change, and why you've chosen this way. Two different questions, and it's better to answer both.

Example:

    problem: no error thrown when --exec used without console/attach cmd
    solution: check for presence of required command when --exec in use

You can omit part of it, if it's obvious from another part. Like:

    solution: typo fixed

or:

    problem: outdated dependencies

For the first example it's clear that the problem was a type, and for second it's clear that you'll update them. Otherwise an explanation will be helpful.

Examples of a **bad** commit message:

    select amount dialog

Why it was required? Is it a problem with existing dialog, or developer have just introduced it? If a user asked for such feature, then why? Does it required for something else? Or maybe it does fix another issue?

More examples of **bad** commit messages:

- Description
- update readme
- contract updated
- clean
- Fixes for X
- Added updated X library

# Branches and Pull Requests

---

 `master` should always have a buildable and working version of the app. All new features or fixes should be implemented in a branch first and submitted as a Pull Request. 

One Pull Request should contain one core change. It can have multiple commits, though.

If there is a big change to the application, which consists of several different things, it's better to create a new branch from master (sat `master -> release-beta3` ) and apply all Pull Requests to this branch. When this big feature is finished, whole branch can be merged into master.

Each pull requests must be approved by another team member. For core project master branch is protected from direct commits. It add extra transparency and a protection from hacked accounts.

It's recommended to make branches in main repository, instead of forking it and making Pull Requests from personal copy. The reason of it that it adds extra complication to other team members, who would want to test your new feature or make extra changes to it. It's easier to switch to a branch, rather than adding a new Git Remote, fetching it and switching to a branch there. So please, _if you respect your coworkers, don't fork projects to your personal repo to work on it_ . Also in some cases it makes troubles to Travis-CI.

- Isaac: I just read this! I bet Wei or Igor wrote it. Sounds good to me. I have been forking to personal and making PRs from there —> **I will change! **

  [](https://media2.giphy.com/media/27EhcDHnlkw1O/giphy-downsized.gif?fingerprint=e1bb72ff59e1314e456a35636fa6efac)