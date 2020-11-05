# Installing Clients

PMM Client is a package of agents and exporters installed on a database host that you want to monitor. Before installing the PMM Client package on each database host that you intend to monitor, make sure that your PMM Server host is accessible.

For example, you can run the `ping` command passing the IP address of the computer that PMM Server is running on. For example:

```sh
ping 192.168.100.1
```

You will need to have root access on the database host where you will be installing PMM Client (either logged in as a user with root privileges or be able to run commands with `sudo`).

**Supported platforms**

PMM Client should run on any modern Linux 64-bit distribution, however Percona provides PMM Client packages for automatic installation from software repositories only on the most popular Linux distributions:

* [DEB packages for Debian-based distributions such as Ubuntu](#debian)
* [RPM packages for Red Hat-based distributions such as CentOS](redhat)

It is recommended that you install your PMM (Percona Monitoring and Management) client by using the
software repository for your system. If this option does not work for you,
Percona provides downloadable PMM Client packages
from the [Download Percona Monitoring and Management](https://www.percona.com/downloads/pmm2/) page.

In addition to DEB and RPM packages, this site also offers:

* Generic tarballs that you can extract and run the included `install` script.
* Source code tarball to build your PMM (Percona Monitoring and Management) client from source.

!!! warning

    You should not install agents on database servers that have the same host name, because host names are used by PMM Server to identify collected data.

**Storage requirements**

Minimum 100 MB of storage is required for installing the PMM Client package. With a good constant connection to PMM Server, additional storage is not required. However, the client needs to store any collected data that it is not able to send over immediately, so additional storage may be required if connection is unstable or throughput is too low.


## Debian

If you are running a DEB-based Linux distribution, you can use the `apt` package manager to install PMM client from the official Percona software repository.

Percona provides `.deb` packages for 64-bit versions of popular Linux distributions.

The list can be found on [Percona’s Software Platform Lifecycle page](https://www.percona.com/services/policies/percona-software-platform-lifecycle/).

!!! note

    Although PMM client should work on other DEB-based distributions, it is tested only on the platforms listed above.

To install the PMM client package, follow these steps.

1. Configure Percona repositories using the [percona-release](https://www.percona.com/doc/percona-repo-config/percona-release.html) tool. First you’ll need to download and install the official `percona-release` package from Percona:

    ```sh
    wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
    sudo dpkg -i percona-release_latest.generic_all.deb
    ```

    !!! note

        If you have previously enabled the experimental or testing Percona repository, don’t forget to disable them and enable the release component of the original repository as follows:

        ```sh
        sudo percona-release disable all
        sudo percona-release enable original release
        ```

2. Install the PMM client package:

    ```sh
    sudo apt-get update
    sudo apt-get install pmm2-client
    ```

3. Register your Node:

    ```sh
    pmm-admin config --server-insecure-tls --server-url=https://admin:admin@<IP Address>:443
    ```

4. You should see the following output:

    ```
    Checking local pmm-agent status...
    pmm-agent is running.
    Registering pmm-agent on PMM Server...
    Registered.
    Configuration file /usr/local/percona/pmm-agent.yaml updated.
    Reloading pmm-agent configuration...
    Configuration reloaded.
    ```

## Red Hat

If you are running an RPM-based Linux distribution, use the `yum` package manager to install PMM Client from the official Percona software repository.

Percona provides `.rpm` packages for 64-bit versions of Red Hat Enterprise Linux 6 (Santiago) and 7 (Maipo), including its derivatives that claim full binary compatibility, such as, CentOS, Oracle Linux, Amazon Linux AMI, and so on.

!!! note

    PMM Client should work on other RPM-based distributions, but it is tested only on RHEL and CentOS versions 6 and 7.

To install the PMM Client package, complete the following procedure. Run the following commands as root or by using the `sudo` command:

1. Configure Percona repositories using the [percona-release](https://www.percona.com/doc/percona-repo-config/percona-release.html) tool. First you’ll need to download and install the official percona-release package from Percona:

    ```sh
    sudo yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm
    ```

    !!! note

        If you have previously enabled the experimental or testing Percona repository, don’t forget to disable them and enable the release component of the original repository as follows:

        ```sh
        sudo percona-release disable all
        sudo percona-release enable original release
        ```

        See [percona-release official documentation](https://www.percona.com/doc/percona-repo-config/percona-release.html) for details.


2. Install the `pmm2-client` package:

    ```sh
    yum install pmm2-client
    ```

3. Once PMM Client is installed, run the `pmm-admin config` command with your PMM Server IP address to register your Node within the Server:

    ```sh
    pmm-admin config --server-insecure-tls --server-url=https://admin:admin@<IP Address>:443
    ```

    You should see the following:

    ```
    Checking local pmm-agent status...
    pmm-agent is running.
    Registering pmm-agent on PMM Server...
    Registered.
    Configuration file /usr/local/percona/pmm-agent.yaml updated.
    Reloading pmm-agent configuration...
    Configuration reloaded.
    ```

## Installing PMM Client via Docker

Docker images of PMM Client are stored at the [percona/pmm-client](https://hub.docker.com/r/percona/pmm-client/tags/)
public repository. The host must be able to run Docker 1.12.6 or later,
and have network access.

Make sure that the firewall and routing rules of the host do not constrain
the Docker container. For more information, see How do I troubleshoot communication issues between PMM Client and PMM Server?.

For more information about using Docker, see the [Docker documentation](https://docs.docker.com).

### Setting Up a Docker Container for PMM Client

A Docker image is a collection of preinstalled software which lets you
run a selected version of PMM Client.
A Docker image is not run directly.
You use it to create a Docker container for your PMM Client.
When launched, the Docker container gives access to the whole functionality
of PMM Client.

* The setup begins by pulling the required Docker image.

* Next, you create a special container for persistent PMM data.

* Finally, you create and launch the PMM Client container.

### Pulling the PMM Client Docker Image

To pull the latest version from Docker Hub:

```sh
docker pull percona/pmm-client:2
```

### Creating a Persistent Data Store for the PMM Client Docker Container

To create a container for persistent data, run the following command:

```sh
docker create -v /srv --name pmm-client-data percona/pmm-client:2 /bin/true
```

!!! note

    This container does not run, but exists only to make sure you retain
all PMM data when upgrading to a newer image.

* The `-v` option initializes a data volume for the container.

* The `--name` option assigns a name for the container
to reference the container within a Docker network.

* `percona/pmm-client:2` is the name and version tag of the image
to derive the container from.

* `/bin/true` is the command that the container runs.

### Run the PMM Client Docker Container

```sh
docker run --rm \
    -e PMM_AGENT_SERVER_ADDRESS=PMMServer:443 \
    -e PMM_AGENT_SERVER_USERNAME=admin \
    -e PMM_AGENT_SERVER_PASSWORD=admin \
    -e PMM_AGENT_SERVER_INSECURE_TLS=1 \
    -e PMM_AGENT_SETUP=1 \
    -e PMM_AGENT_CONFIG_FILE=pmm-agent.yml \
    --volumes-from pmm-client-data \
    perconalab/pmm-client:dev-latest
```

### ENVIRONMENT VARIABLES

`PMM_AGENT_SERVER_ADDRESS`
: The PMM Server hostname and port number.

`PMM_AGENT_SERVER_USERNAME`
: The PMM Server user name.

`PMM_AGENT_SERVER_PASSWORD`
: The PMM Server user’s password.

`PMM_AGENT_SERVER_INSECURE_TLS`
: If true (1), use insecure TLS. Otherwise, do not.

`PMM_AGENT_SETUP`
: If true (1), run `pmm-agent setup`. Default: false (0).

`PMM_AGENT_CONFIG_FILE`
: The PMM Agent configuration file.

To get help:

```sh
docker run --rm perconalab/pmm-client:dev-latest --help
```


## Configuring PMM Client with `pmm-admin config`

### Connecting PMM Clients to the PMM Server

With your server and clients set up, you must configure each PMM Client and
specify which PMM Server it should send its data to.

To connect a PMM Client, enter the IP address of the PMM Server as the value
of the `--server-url` parameter to the `pmm-admin config` command, and
allow using self-signed certificates with `--server-insecure-tls`.

!!! note

    The `--server-url` argument should include `https://` prefix and PMM Server credentials, which are `admin`/`admin` by default, if not changed at first PMM Server GUI access.

Run this command as root or by using the `sudo` command

```sh
pmm-admin config --server-insecure-tls --server-url=https://admin:admin@192.168.100.1:443
```

For example, if your PMM Server is running on 192.168.100.1, you have installed PMM Client on a machine with IP 192.168.200.1, and didn’t change default PMM Server credentials, run the following in the terminal of your client. Run the following commands as root or by using the `sudo` command:

```sh
pmm-admin config --server-insecure-tls --server-url=https://admin:admin@192.168.100.1:443
```

```
Checking local pmm-agent status...
pmm-agent is running.
Registering pmm-agent on PMM Server...
Registered.
Configuration file /usr/local/percona/pmm-agent.yaml updated.
Reloading pmm-agent configuration...
Configuration reloaded.
Checking local pmm-agent status...
pmm-agent is running.
```

If you change the default port 443 when running PMM Server, specify the new port number after the IP address of PMM Server.

!!! note

    By default `pmm-admin config` refuses to add client if it already exists in the PMM Server inventory database. If you need to re-add an already existing client (e.g. after full reinstall, hostname changes, etc.), you can run `pmm-admin config` with the additional `--force` option. This will remove an existing node with the same name, if any, and all its dependent services.


## Removing services

Use the `pmm-admin remove` command to remove monitoring services.

### USAGE

Run this command as root or by using the `sudo` command

```sh
pmm-admin remove [OPTIONS] [SERVICE-TYPE] [SERVICE-NAME]
```

When you remove a service,
collected data remains in Metrics Monitor on PMM Server for the specified [retention period](https://www.percona.com/doc/percona-monitoring-and-management/2.x/faq.html#how-to-control-data-retention-for-pmm).

### SERVICES

Service type can be mysql, mongodb, postgresql or proxysql, and service
name is a monitoring service alias. To see which services are enabled,
run `pmm-admin list`.

### EXAMPLES

```sh
# Removing MySQL service named mysql-sl
pmm-admin remove mysql mysql-sl

# remove MongoDB service named mongo
pmm-admin remove mongodb mongo

# remove PostgreSQL service named postgres
pmm-admin remove postgresql postgres

# remove ProxySQL service named ubuntu-proxysql
pmm-admin remove proxysql ubuntu-proxysql
```

For more information, run `pmm-admin remove --help`.
