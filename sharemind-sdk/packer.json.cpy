{
    "variables": {
        "files_destination": "/tmp/files",
        "headless": "true",
        "output_directory": "output",
        "profile_visalizer_reporev": "ede1afdb074d8af9cfe4a9ff13a2b1a7ecde18fc",
        "profile_visalizer_repourl": "https://github.com/sharemind-sdk/profile_log_visualizer.git",
        "sharemind_reporev": "12345165b5b9a58c3c7153ed911272a4407664e8",
        "sharemind_repourl": "https://github.com/sharemind-sdk/build-sdk.git",
        "ssh_password": "sharemind",
        "ssh_username": "sharemind",
        "vm_cpus": "2",
        "vm_export_cpus": "1",
        "vm_export_memory": "1024",
        "vm_export_product": "Sharemind SDK",
        "vm_export_producturl": "https://sharemind.cyber.ee/",
        "vm_export_vendor": "Cybernetica AS",
        "vm_export_vendorurl": "https://cyber.ee/",
        "vm_export_version": "2015.12",
        "vm_memory": "1024",
        "vm_name": "2015.12-sharemind-sdk-debian-8.2.0-amd64",
        "vm_source_path": "../sharemind-sdk-base/output/sharemind-sdk-base.ova"
    },
    "builders": [
        {
            "type": "virtualbox-ovf",
            "export_opts": [
                "--vsys", "0",
                "--product", "{{ user `vm_export_product` }}",
                "--producturl", "{{ user `vm_export_producturl` }}",
                "--vendor", "{{ user `vm_export_vendor` }}",
                "--vendorurl", "{{ user `vm_export_vendorurl` }}",
                "--version", "{{ user `vm_export_version` }}"
            ],
            "format": "ova",
            "guest_additions_mode": "upload",
            "headless": "{{ user `headless` }}",
            "output_directory": "{{ user `output_directory` }}",
            "shutdown_command": "echo '{{ user `ssh_password` }}' | sudo -S shutdown -P now",
            "source_path": "{{ user `vm_source_path` }}",
            "ssh_password": "{{ user `ssh_password` }}",
            "ssh_username": "{{ user `ssh_username` }}",
            "vboxmanage": [
                ["modifyvm", "{{ .Name }}", "--cpus", "{{ user `vm_cpus` }}"],
                ["modifyvm", "{{ .Name }}", "--memory", "{{ user `vm_memory` }}"]
            ],
            "vboxmanage_post": [
                ["modifyvm", "{{ .Name }}", "--cpus", "{{ user `vm_export_cpus` }}"],
                ["modifyvm", "{{ .Name }}", "--memory", "{{ user `vm_export_memory` }}"]
            ],
            "vm_name": "{{ user `vm_name` }}"
        }
    ],
    "provisioners": [
        {
            "type": "file",
            "destination": "{{ user `files_destination` }}",
            "source": "files"
        },
        {
            "type": "shell",
            "environment_vars": [
                "DE_AUTOLOGIN_USERNAME={{ user `ssh_username` }}",
                "DE_DESKTOP_BG_COLOR=#363636",
                "DE_DESKTOP_BG_MODE=fit",
                "PV_REPO_PATH=/usr/local/src/profile_log_visualizer.git",
                "PV_REPO_REV={{ user `profile_visalizer_reporev` }}",
                "PV_REPO_URL={{ user `profile_visalizer_repourl` }}",
                "PV_INSTALL_PATH=/usr/local",
                "PV_SCRIPTS_PATH={{ user `files_destination` }}/profile-visualizer/scripts",
                "SDK_BG_IMG_PATH={{ user `files_destination` }}/sdk/desktop-bg-emulator.png",
                "SDK_INSTALL_PATH=/usr/local",
                "SDK_SCRIPTS_PATH={{ user `files_destination` }}/sdk/scripts",
                "SM_BUILD_PATH=/usr/local/src/sharemind-sdk.git/build",
                "SM_CONFIG_PATH={{ user `files_destination` }}/sharemind/config.local",
                "SM_INSTALL_PATH=/usr/local/sharemind",
                "SM_REPO_PATH=/usr/local/src/sharemind-sdk.git",
                "SM_REPO_REV={{ user `sharemind_reporev` }}",
                "SM_REPO_URL={{ user `sharemind_repourl` }}"
            ],
            "execute_command": "echo '{{ user `ssh_password` }}' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'",
            "scripts": [
                "scripts/root/sharemind.sh",
                "scripts/root/profile-visualizer.sh",
                "scripts/root/desktop-environment.sh",
                "scripts/root/qtcreator.sh",
                "scripts/root/sdk.sh"
            ]
        },
        {
            "type": "shell",
            "environment_vars": [
                "SDK_FILES_PATH={{ user `files_destination` }}/sdk/sdk-files",
                "SDK_DESKTOP_ICONS_PATH={{ user `files_destination` }}/sdk/Desktop",
                "SDK_SM_CONFIG_PATH={{ user `files_destination` }}/sdk/sharemind-config",
                "QTCREATOR_CONFIG_PATH={{ user `files_destination` }}/qtcreator"
            ],
            "scripts": [
                "scripts/user/qtcreator.sh",
                "scripts/user/sdk.sh"
            ]
        },
        {
            "type": "shell",
            "environment_vars": [
                "CLEANUP_ZEROFREE_SERVICE={{ user `files_destination` }}/cleanup/zerofree",
                "CLEANUP_ZEROFREE_SYSTEMD_SERVICE={{ user `files_destination` }}/cleanup/zerofree.service"
            ],
            "execute_command": "echo '{{ user `ssh_password` }}' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'",
            "scripts": [
                "scripts/root/virtualbox.sh",
                "scripts/root/cleanup.sh"
            ]
        }
    ]
}
