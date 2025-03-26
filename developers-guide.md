# Add a New Target to the Chef Cookbook

This guide is for developers who want to add support for a new target in the `newrelic_install` cookbook.

### 1. Setup Workstation

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

### 2. Add target to `chef-install` repository

- **Clone `chef-install` repository:**
    ```bash
    git clone https://github.com/newrelic/chef-install.git
    cd chef-install
    ```

- **Add target agent name in `resources/newrelic_install.rb`:**

  **Note:** The installer names can be found in the recipes of the [open-install-library](https://github.com/newrelic/open-install-library) repository.

  **Example: Adding Support for Java Agent:**
  - First, retrieve the agent installer name from the [Node](https://github.com/newrelic/open-install-library/blob/main/recipes/newrelic/apm/node/linux.yml) recipe.
    All agent recipes can be found in `recipes/newrelic` directory.
    The `name` attribute at the top of the .yml file (e.g., `linux.yml`) corresponds to the agent installer name needed for the `allowed_targets`.

    ![image](https://github.com/user-attachments/assets/7c64ebc2-00ae-4af7-b620-14059fbf2085)

  - After retrieving the installer name, add it to the `allowed_targets` in `resources/newrelic_install.rb`.
    From the previous example, updated `allowed_targets` for the Node agent will look like this:

    ![image](https://github.com/user-attachments/assets/d4a7e5e1-4b4e-4758-8543-9adb5328e363)

- **Add target agent name in `attributes/default.rb`:**

  ![image](https://github.com/user-attachments/assets/56ce960f-d2ab-4632-91bd-06033633b393)

### 3. Test Changes Locally

- Before testing the changes, make sure the required environment variables such as API keys and targeted installs are configured properly in `attributes/default.rb`
- To test your changes locally, execute the following command:
  
    ```bash
    cd chef-install
    chef-client -z -r "recipe[chef-install::default]"
    ```

