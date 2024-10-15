#!/bin/bash


# Function to display usage information
function show_help {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -c, --create    Create a new user account"
    echo "  -d, --delete    Delete an existing user account"
    echo "  -r, --reset     Reset the password of an existing user account"
    echo "  -l, --list      List all user accounts"
    echo "  -h, --help      Show this help message"
}


# Function to create a new user account
function create_user {
    read -p "Enter new username: " username
    # Check if the username already exists
    if id "$username" &>/dev/null; then
        echo "Error: User '$username' already exists."
        exit 1
    fi
    read -sp "Enter password for $username: " password
    echo
    # Create the user account
    useradd -m -p "$(openssl passwd -1 "$password")" "$username"
    echo "User  '$username' created successfully."
}


# Function to delete an existing user account
function delete_user {
    read -p "Enter username to delete: " username
    # Check if the username exists
    if ! id "$username" &>/dev/null; then
        echo "Error: User '$username' does not exist."
        exit 1
    fi
    # Delete the user account
    userdel -r "$username"
    echo "User  '$username' deleted successfully."
}


# Function to reset the password of an existing user account
function reset_password {
    read -p "Enter username to reset password: " username
    # Check if the username exists
    if ! id "$username" &>/dev/null; then
        echo "Error: User '$username' does not exist."
        exit 1
    fi
    read -sp "Enter new password for $username: " password
    echo
    # Reset the password
    echo "$username:$(openssl passwd -1 "$password")" | chpasswd
    echo "Password for user '$username' reset successfully."
}


# Function to list all user accounts
function list_users {
    echo "User  accounts on the system:"
    awk -F: '{ print $1, $3 }' /etc/passwd
}


# Check for command-line arguments
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi


# Parse command-line options
while [[ "$1" != "" ]]; do
    case $1 in
        -c | --create )    create_user
                           ;;
        -d | --delete )    delete_user
                           ;;
        -r | --reset )     reset_password
                           ;;
        -l | --list )      list_users
                           ;;
        -h | --help )      show_help
                           exit
                           ;;
        * )                echo "Invalid option: $1"
                           show_help
                           exit 1
    esac
    shift
done


