# zetifi-serverless-template
Boilerplate template repository for Serverless framework.

Using this template does not replace reviewing existing projects to follow existing project patterns.

# How to
Use this repository as a GitHub template when creating a new repository, which includes helpful workflows to test and deploy.

[**Click me!**](https://github.com/Zetifi/zetifi-serverless-template/generate) to generate new Serverless Framework repository.

# Features
- Standard Serverless framework configuration with base Traceback alarms and Pipfile packaging.
- Action to run pytest on Pull Request (or unittest)
- Action to deploy to AWS on Push. Push to `master` will deploy to live, push to `dev` will deploy to dev. (Also runs tests)

# Template usage
1. Please name the repository according to the format `zetifi-serverless-{xyz}`.
2. Ensure to review service name in `serverless.yml`.
3. Remove any specified plugins that you will not be using in `package.json` and `serverless.yml`.
4. Move preferred GitHub workflows to `.github/workflows` directory to enable them, remove any others. See [Workflows](https://github.com/Zetifi/zetifi-serverless-template?tab=readme-ov-file#workflows).

## serverless.yml
- CLI options:
  - Stage: `--stage [dev|live]` defaults to dev if not specified.
  - Region: `--region ap-southeast-2` defaults to ap-southeast-2 if not specified.
- Common variables for `serverless.yml`:
  - Stage: `${sls:stage}`
  - Region: `${aws:region}`
  - AccountID: `${aws:accountId}`

## Workflows
Each deploy workflow requires some configuration on each individual repository. All workflows are disabled by default, pick and choose which you want to use by moving them to the correct irectory and deleting the rest.

You must configure a live (and dev if required) environment in GitHub. For each environment, you should add a variable or secret (one, not both) named `DOTENV` with the contents of the `.env` file for the respective environment (Found in LastPass).



- deploy.yml
  - Runs Pytest verbose
  - Deploys to the live environment upon push to master
- deploy-no-test.yml
  - Does not run tests
  - Deploys to the live environment upon push to master
- deploy-with-dev.yml
  - Runs Pytest verbose
  - Deploys to the live environment upon push to master
  - Deploys to the dev enviornment when manually triggered via the Actions page
- pytest.yml
  - Runs Pytest verbose
  - *Unittest not supported*

## Please replace the contents of README.md with README-EXAMPLE.md once your repository is created.
