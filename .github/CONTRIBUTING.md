Safe Notes contribution guidelines
===============================


## Issue reporting/feature requests

* **Already reported**? Browse the [existing issues](https://github.com/keshav-space/safe_notes/issues) to make sure your issue/feature hasn't been reported/requested.
* **Already fixed**? Check whether your issue/feature is already fixed/implemented.
* **Still relevant**? Check if the issue still exists in the latest release/beta version.
* **Can you fix it**? If you are an Android/Java/Flutter developer, you are always welcome to fix an issue or implement a feature yourself. PRs welcome! See [Code contribution](#code-contribution) for more info.
* **Is it in English**? Issues in other languages will be ignored unless someone translates them.
* **Is it one issue**? Multiple issues require multiple reports, that can be linked to track their statuses.

## Code contribution

### Guidelines

* Stick to Safe Notes's `minimalist style`.
* Stick to [Google developer guidelines](https://play.google.com/about/developer-content-policy/).
* In particular **do not bring non-free software** (e.g. binary blobs) into the project.

### Before starting development

* If you want to help out with an existing bug report or feature request, **leave a comment** on that issue saying you want to try your hand at it.
* If there is no existing issue for what you want to work on, **open a new one**  describing the changes you are planning to introduce. This gives the team and the community a chance to give **feedback** before you spend time on something that is already in development, should be done differently, or should be avoided completely.
* Please show **intention to maintain your features** and code after you contribute a PR. Unmaintained code is a hassle for core developers. If you do not intend to maintain features you plan to contribute, please rethink your submission, or clearly state that in the PR description.
* Create PRs that cover only **one specific issue/solution/bug**. Do not create PRs that are huge monoliths and could have been split into multiple independent contributions.

### Flutter in Safe Notes
* Safe Notes will remain mostly Flutter for time being

### Creating a Pull Request (PR)

* Make changes on a **separate branch** with a meaningful name, not on the _master_ branch or the _dev_ branch. This is commonly known as *feature branch workflow*. You may then send your changes as a pull request (PR) on GitHub.
* Please **test** (compile and run) your code before submitting changes! Ideally, provide test feedback in the PR description. Untested code will **not** be merged!
* Respond if someone requests changes or otherwise raises issues about your PRs.
* Try to figure out yourself why builds on our CI fail.
* Make sure your PR is **up-to-date** with the rest of the code. Often, a simple click on "Update branch" will do the job, but if not, you must resolve the conflicts on your own. Doing this makes the maintainers' job way easier.
* Use `meaningful` commit message and don't forget to add your `DCO` at the end of every commit message.

## Communication

* Connect to us on GitHub [Discussion](https://github.com/keshav-space/safenotes/discussions) **(preferred)**
* The #safenotes channel on [Matrix Chat](https://matrix.to/#/#safenotes:matrix.org) has the core team and other developers in it.
* You can post your suggestions, changes, ideas etc. on either `GitHub` or `Matrix`.
