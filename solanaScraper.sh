#!/bin/bash

# Function to log errors
log_error() {
    local error_message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ERROR: $error_message" >> /home/meer2911/Desktop/solanaScraper.log
}

# Fetch the webpage
webpage=$(curl -s 'https://coinmarketcap.com/currencies/solana/')

# Check if curl command was successful
if [ $? -ne 0 ]; then
    log_error "Failed to fetch webpage. Check network connection or website availability."
    exit 1
fi

# Extract the Solana price using grep and awk
solana_prices=$(echo "$webpage" | grep -o '<span class="sc-f70bb44c-0 jxpCgO base-text">\$[0-9,.]*</span>' | awk -F '</span>' '{print $1}' | sed 's/<span class="sc-f70bb44c-0 jxpCgO base-text">//;s/,//g;s/\$//')

# Check if solana_prices is not empty
if [ -n "$solana_prices" ]; then
    # Database credentials
    db_host='localhost'
    db_user='root'
    db_pass='password'
    db_name='scraper_db'

    # SQL query
    sql="INSERT INTO solana_prices (rate) VALUES ('$solana_prices')"

    # Run the SQL query
    mysql -h $db_host -u $db_user -p$db_pass $db_name -e "$sql"
    if [ $? -eq 0 ]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Data extracted: $solana_prices" >> /home/meer2911/Desktop/solanaScraper.log
    else
        log_error "Failed to insert data into database."
    fi
else
    log_error "Failed to extract Solana price."
fi
