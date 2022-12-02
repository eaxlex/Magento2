#!/bin/sh

start ()
{
    php bin/magento cache:clean
    php bin/magento cache:flush
    php bin/magento setup:upgrade
}

install ()
{
    echo "Creating Directory for Mktr"
    mkdir -p app/code/Mktr
    echo "Copy Files Mktr"
    cp -rf mktr/app/code/Mktr/Tracker app/code/Mktr
    read -p "Almost Done, Press enter to continue "

    php bin/magento module:enable --clear-static-content Mktr_Tracker
    php bin/magento setup:upgrade
    php bin/magento setup:di:compile
    php bin/magento cache:flush
    php bin/magento setup:static-content:deploy
    php bin/magento cache:clean
}

uninstall ()
{
    read -r -p "Are you sure? [Y/n]" response
    response=${response,,} # tolower
    if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then

        php bin/magento module:disable --clear-static-content Mktr_Tracker
        php bin/magento module:uninstall Mktr_Tracker
        php bin/magento setup:upgrade
        php bin/magento setup:di:compile
        php bin/magento cache:flush
        php bin/magento setup:static-content:deploy

        rm -rf app/code/Mktr/Tracker
    fi
}

if [ -z "$1" ]; then
    start
else
    $1
fi



