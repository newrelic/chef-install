## Add a New Target to the Chef Cookbook

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

- **Add target agent name in `resources/newrelic_install.rb` and `attributes/default.rb`:**
    
  ![image](https://github.com/user-attachments/assets/d4a7e5e1-4b4e-4758-8543-9adb5328e363)

  ![image](https://github.com/user-attachments/assets/56ce960f-d2ab-4632-91bd-06033633b393)

### 3. Test Changes Locally

- Before testing the changes, make sure the required environment variables such as API keys and targeted installs are configured properly in `attributes/default.rb`
- To test your changes locally, execute the following command:
  
    ```bash
    cd chef-install
    chef-client -z -r "recipe[chef-install::default]"
    ```

