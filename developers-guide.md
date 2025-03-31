# Add a New Target to the Chef Cookbook

This guide is for developers who want to add support for a new target in the `newrelic_install` cookbook.

### Step 1: Setup Workstation

- **Download and Install Chef Workstation**

    Download the Chef Workstation source file based on your operating system. For different releases or earlier versions, visit the [Chef Workstation Downloads page](https://www.chef.io/downloads). For detailed installation instructions, refer to the [Chef Workstation Installation Documentation](https://docs.chef.io/workstation/install_workstation/).

- **Download the Chef Workstation package:**
  ```bash
  wget https://packages.chef.io/files/stable/chef-workstation/22.10.1013/ubuntu/20.04/chef-workstation_22.10.1013-1_amd64.deb
  ```

- **Install the Chef Workstation package:**
  ```bash
  sudo dpkg -i chef-workstation_*.deb
  ```

- **Remove the source file:**
  ```bash
  rm chef-workstation_*.deb
  ```

- **Verify installation:**
  ```bash
  chef -v
  ```

### Step 2: Add target to `chef-install` repository

- **Clone `chef-install` repository:**
    ```bash
    git clone https://github.com/newrelic/chef-install.git
    cd chef-install
    ```

- **Add target agent name in `chef-install`:**

  **Note:** The installer names can be found in the recipes of the [open-install-library](https://github.com/newrelic/open-install-library) repository.

  **Example: Adding Support for Node Agent:**
  - First, retrieve the agent installer name from the [Node](https://github.com/newrelic/open-install-library/blob/main/recipes/newrelic/apm/node/linux.yml) recipe.
    All agent recipes can be found in `recipes/newrelic` directory.
    The `name` attribute at the top of the .yml file (e.g., `linux.yml`) corresponds to the agent installer name needed for the `allowed_targets`.

    ![image](https://github.com/user-attachments/assets/7c64ebc2-00ae-4af7-b620-14059fbf2085)

  - After retrieving the installer name, add it to the `allowed_targets` in `resources/newrelic_install.rb`.
    From the previous example, updated `allowed_targets` for the Node agent will look like this:

    ![image](https://github.com/user-attachments/assets/d4a7e5e1-4b4e-4758-8543-9adb5328e363)

  - **Add target agent name in `attributes/default.rb`:**

    ![image](https://github.com/user-attachments/assets/8cfe577e-8ae7-4939-bc56-4386e6b9dcb2)

### Step 3: Testing the target locally

- **Configure `attributes/default.rb`**

    Add the target agent name to the targets attribute and include any environment variables required by the agent (Note: To locate the environment variables for a specific agent, please refer to the configuration section of the specific [agent](https://docs.newrelic.com/docs/apm/new-relic-apm/getting-started/introduction-apm/) documentation).
  
  ![image](https://github.com/user-attachments/assets/2c94eaac-16ea-444a-b2ba-61e7d685a8f3)

- To test your changes locally, execute the following command:
  
    ```bash
    cd chef-install
    chef-client -z -r "recipe[chef-install::default]"
    ```

    **Note: Upon executing the above command, the cookbook will utilize the New Relic CLI to perform target installations included in `attributes/default.rb`. All targets in this cookbook depend on the New Relic CLI for installation.**

    ![image](https://github.com/user-attachments/assets/36204f9c-f541-4482-8ebc-3d553b90f320)


**Note: If you are a developer who want to add support for a new target agent in the `newrelic_install` cookbook, the instructions in this guide for adding a new target agent support will only modify the local copy of the `newrelic_install` cookbook.**

**To make these changes live, you will need to:**
- **Create a pull request ([reference PR](https://github.com/newrelic/chef-install/pull/17)) with your modifications.**
- **Once the PR is merged, the changes will be released.**
- **After the changes are merged and released, the `newrelic_install` cookbook will be updated on Chef Supermarket.**
