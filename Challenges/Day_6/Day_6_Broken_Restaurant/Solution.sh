#!/bin/bash

# Welcome to The Hungry Bash - Restaurant Order System

# Fun. to display the menu
display_menu() {
    echo "Menu:"
    echo "---------------------------------"
    while IFS=, read -r dish price; do
        echo "$dish - Rs.$price"
    done < menu.txt
    echo "---------------------------------"
}

# Fun. to get valid user input
get_valid_input() {
    local prompt="$1"
    local input

    while true; do
        read -p "$prompt" input
        if [[ "$input" =~ ^[0-9]+$ ]]; then
            echo "$input"
            return
        else
            echo "Invalid input. Please enter a valid number."
        fi
    done
}

# Fun. to calculate the total bill
calculate_total() {
    local total=0
    while IFS=, read -r dish price; do
        for item in "${ordered_items[@]}"; do
            if [[ "$item" == "$dish" ]]; then
                total=$((total + price))
            fi
        done
    done < menu.txt
    echo "Total Bill: Rs.$total"
}

# Main script starts here
ordered_items=()

echo "Welcome to The Hungry Bash Restaurant!"
display_menu

while true; do
    echo "Please enter the name of the dish you want to order (or type 'done' to finish):"
    read dish_name

    if [[ "$dish_name" == "done" ]]; then
        break
    fi

    if grep -qi "^$dish_name," menu.txt; then
        ordered_items+=("$dish_name")
    else
        echo "Dish not found. Please enter a valid dish name."
    fi
done

if [[ ${#ordered_items[@]} -eq 0 ]]; then
    echo "No items ordered. Exiting."
    exit 0
fi

echo "Your order:"
for item in "${ordered_items[@]}"; do
    echo "- $item"
done

calculate_total

echo "Thank you for dining with us!"
