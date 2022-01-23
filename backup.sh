#!bin/bash


# This Script will Make a Backup for The Pycharm Automatically To a Specific External Hard Drive

# Defining a variable
#####################################################################################################################################################################
#1- Getting The date of the day to include with the backup
DATE=$(date +%d-%m-%Y)

#2- Getting The Pycharm Project forlder Path to Backup
PYCHARM_PROJECTS_PATH="/home/root-x/PycharmProjects"
readonly PYCHARM_PROJECTS_PATH

#3- Getting The Flutter Project Folder Path to Backup
FLUTTER_PROJECTS_PATH="/home/root-x/StudioProjects"
readonly FLUTTER_PROJECTS_PATH

#4- Getting The Django Project Folder Path to Backup
DJANGO_PROJECTS_PATH="/home/root-x/Desktop/Django"
readonly DJANGO_PROJECTS_PATH

#5- Backup Drive Path or ID   "/media/root-x/ACCC-3C54"
BACKUP_DRIVE_PATH="/media/root-x/ACCC-3C54/Code"
readonly BACKUP_DRIVE_PATH

#6- Local Backup Folder Path
LOCAL_BACKUP_PATH="/home/root-x/Backup_Projects"
readonly LOCAL_BACKUP_PATH

#7- Define My WorkSpace array
MY_WORKSPACE_ARRAY=("Pycharm" "Flutter" "Django" "Bash")
readonly MY_WORKSPACE_ARRAY

#8- Defining an array for each platform to hold the names of local backedup but not external projects
PYCHARM_ARRAY=()
FLUTTER_ARRAY=()
DJANGO_ARRAY=()
BASH_ARRAY=()

#9- Define Bash Script Folder Path
BASH_SCRIPT_PATH="/home/root-x/bin"
readonly BASH_SCRIPT_PATH

#10- Define Bash Script With Folder Location Path To Backup From
BASH_LOCAL_BACKUP_FOLDERS="/home/root-x/Backup_Projects/Bash"
readonly BASH_LOCAL_BACKUP_FOLDERS


# Defining Funtions
#####################################################################################################################################################################
# You can use (readonly -f) to make the function readonly or to show the read only functions
# you can use (readonly -p) to show all the pre-defined readonly variable or by just (readonly) 

#1- Listing The Exsicting Files Function
show_files(){
    cd $1
    echo ""
    echo "Choose The File You Want To Backup: "
    echo ""
    echo "-------------------------------------------------------------------------------"
    echo ""

    i=1
    for item in *
    do 
        if [[ -d $item || -f $item ]]
        then
            echo $i-$item
        fi
        (( i ++ ))
    done

    echo ""
    echo "-------------------------------------------------------------------------------"
    echo ""

    # Ask The User To Enter The Project Name
    echo -e "Enter The File Name: \c"
    read option

    echo ""
    echo "-------------------------------------------------------------------------------"
    echo ""
}

#2- Checking if the Backup Hard Drive is Attached

backup_location(){
    # Check if the backup drive is attached
    if [ -d $BACKUP_DRIVE_PATH/$1 ] 
    then # check the external hard drive
        
        EXTERNAL_IS_ATTACHED="True"
        # Location of where to Backup
        echo -e "DO you want to Backup Locally or External (L/E)?: \c"
        read choice

        echo ""
        echo "-------------------------------------------------------------------------------"
        echo ""
        
    else # if not attached 
        choice="L"
    fi
}

#3- Backup Function

start_backup(){
    # Perform The Bachup
    # The Project Name is $option
    # $BASH_LOCAL_BACKUP_FOLDERS for bash files
    
    # The Directory Folder To Backup Path
    folder_path=$1

    # The backup Platform is $2
    platform=$2

    # Local Backup
    if [[ $choice = "L" || $choice = "l" ]]
    then
        # Check First If It's A Bash Script Because The Location Will Be Diffrenet
        if [[ $platform == "Bash" ]]
        then
            zip -rm $BASH_LOCAL_BACKUP_FOLDERS/$option $folder_path
            echo "The File Had Been Backed-Up To Local Back-Up"
        else
            zip -r $LOCAL_BACKUP_PATH/$platform/$option $folder_path/$option
            echo "The File Had Been Backed-Up To Local Backup"
        fi

    # External Backup   
    elif [[ $choice = "E" || $choice = "e" ]]
    then
        # Check First If It's A Bash Script Because The Location Will Be Diffrenet
        if [[ $platform == "Bash" ]]
        then
            zip -rm $BACKUP_DRIVE_PATH/$platform/$option $folder_path
            echo "You Are in $platform External Backup"
        else
            zip -r $BACKUP_DRIVE_PATH/$platform/$option $folder_path/$option
            echo "You Are in $platform External Backup"
        fi

    else
        echo "Your choice is invalid"
    fi
}

#4- Checking Local Backuped files And Not In The External Backup Drive Function

check_backup(){ 
    FOLDER_TO_CHECK="${MY_WORKSPACE_ARRAY[$1]}"
    
    cd $LOCAL_BACKUP_PATH/$FOLDER_TO_CHECK
    item_order=$2
    for item in *
    do
        
        if [[ -e "$BACKUP_DRIVE_PATH/$FOLDER_TO_CHECK/$item" &&  $item.zip ]]
        then
            echo ""
        else
            if [ $FOLDER_TO_CHECK == "Pycharm" ]
            then
                PYCHARM_ARRAY[$item_order]=$item
            elif [ $FOLDER_TO_CHECK == "Flutter" ]
            then
                FLUTTER_ARRAY[$item_order]=$item
            elif [ $FOLDER_TO_CHECK == "Django" ]
            then
                DJANGO_ARRAY[$item_order]=$item
            elif [ $FOLDER_TO_CHECK == "Bash" ]
            then
                BASH_ARRAY[$item_order]=$item
            fi
            (( item_order ++ ))
            
        fi
    done
    
}

#5- Copy Local Backup To External

copy_local_external(){

    # Which Platform To Copy
    platform=$1  

    # LOCAL_BACKUP_PATH

    if [ $platform == "Pycharm" ]
    then
        for (( file_index = 0; file_index < $UN_BACKEDUP_PYCHARM_LENGTH ; file_index++))
        do
            cp -r $LOCAL_BACKUP_PATH/$platform/"${PYCHARM_ARRAY[file_index]}" $BACKUP_DRIVE_PATH/$platform/"${PYCHARM_ARRAY[file_index]}"
        done
    elif [ $platform == "Flutter" ]
    then
        for (( file_index = 0; file_index < $UN_BACKEDUP_FLUTTER_LENGTH ; file_index++))
        do
            cp -r $LOCAL_BACKUP_PATH/$platform/"${FLUTTER_ARRAY[file_index]}" $BACKUP_DRIVE_PATH/$platform/"${FLUTTER_ARRAY[file_index]}" 
        done
    elif [ $platform == "Django" ]
    then
        for (( file_index = 0; file_index < $UN_BACKEDUP_DJANGO_LENGTH ; file_index++))
        do
            cp -r $LOCAL_BACKUP_PATH/$platform/"${DJANGO_ARRAY[file_index]}" $BACKUP_DRIVE_PATH/$platform/"${DJANGO_ARRAY[file_index]}"
        done
    elif [ $platform == "Bash" ]
    then
        for (( file_index = 0; file_index < $UN_BACKEDUP_BASH_LENGTH ; file_index++))
        do
            cp -r $LOCAL_BACKUP_PATH/$platform/"${BASH_ARRAY[file_index]}" $BACKUP_DRIVE_PATH/$platform/"${BASH_ARRAY[file_index]}"
        done
    fi

}

#6- Ask The User As The External Back-Up Drive Is Attached If He Wants To Do External Back-Up
user_choice(){
    for number in {0..3}
    do
        array_item=0
        check_backup $number $array_item
    done

    # Getting The Lenght of the files backed up to local but not to external
    UN_BACKEDUP_PYCHARM_LENGTH="${#PYCHARM_ARRAY[@]}"
    UN_BACKEDUP_FLUTTER_LENGTH="${#FLUTTER_ARRAY[@]}"
    UN_BACKEDUP_DJANGO_LENGTH="${#DJANGO_ARRAY[@]}"
    UN_BACKEDUP_BASH_LENGTH="${#BASH_ARRAY[@]}"

    # Check If There Are Pycharm Files Backed Up to Local But Not To External
    if [[ $UN_BACKEDUP_PYCHARM_LENGTH -ne 0 && "${PYCHARM_ARRAY[0]}" != "*" ]]
    then
        echo " Those Pycharm Projects Are Backed Up Locally, Do You Want To Back Them To The External Drive"
        echo "${PYCHARM_ARRAY[@]}"
        read -p "(Y/N)? " user_option

        # If The user Respond With Yes The Files Will be Copied To The External Hard Drive
        if [[ $user_option = "Y" || $user_option = "y" ]]
        then
            copy_local_external Pycharm
        fi
    fi

    # Check If There Are Flutter Files Backed Up to Local But Not To External
    if [[ $UN_BACKEDUP_FLUTTER_LENGTH -ne 0 && "${FLUTTER_ARRAY[0]}" != "*" ]]
    then
        echo " Those Flutter Projects Are Backed Up Locally, Do You Want To Back Them To The External Drive"
        echo "${FLUTTER_ARRAY[@]}"
        read -p "(Y/N)? " user_option

        # If The user Respond With Yes The Files Will be Copied To The External Hard Drive
        if [[ $user_option = "Y" || $user_option = "y" ]]
        then
            copy_local_external Flutter
        fi
    fi

    # Check If There Are Django Files Backed Up to Local But Not To External
    if [[ $UN_BACKEDUP_DJANGO_LENGTH -ne 0 && "${DJANGO_ARRAY[0]}" != "*" ]]
    then
        echo " Those Django Projects Are Backed Up Locally, Do You Want To Back Them To The External Drive"
        echo "${DJANGO_ARRAY[@]}"
        read -p "(Y/N)? " user_option

        # If The user Respond With Yes The Files Will be Copied To The External Hard Drive
        if [[ $user_option = "Y" || $user_option = "y" ]]
        then
            copy_local_external Django
        fi
    fi

    # Check If There Are Bash Files Backed Up to Local But Not To External
    if [[ $UN_BACKEDUP_BASH_LENGTH -ne 0 && "${BASH_ARRAY[0]}" != "*" ]]
    then
        echo " Those Bash Projects Are Backed Up Locally, Do You Want To Back Them To The External Drive"
        echo "${BASH_ARRAY[@]}"
        read -p "(Y/N)? " user_option

        # If The user Respond With Yes The Files Will be Copied To The External Hard Drive
        if [[ $user_option = "Y" || $user_option = "y" ]]
        then
            copy_local_external Bash
        fi
    fi

    if [[ $UN_BACKEDUP_PYCHARM_LENGTH -eq 0 && $UN_BACKEDUP_FLUTTER_LENGTH -eq 0  ]]
    then
        if [[ $UN_BACKEDUP_DJANGO_LENGTH -eq 0 && $UN_BACKEDUP_BASH_LENGTH -eq 0 ]]
        then
            echo "Great Your Files Looks Uptodate !"
        fi
    fi
}


# Case Statment 
#####################################################################################################################################################################
case $1 in 
    # PYCHARM
    -p | --Pycharm )
        # This Option is to Backup Pycharm Projects By The Provided Project Name

        # Calling the function to list all files
        show_files $PYCHARM_PROJECTS_PATH

        # Check if the Entered File Name Excist First
        if [ -d $PYCHARM_PROJECTS_PATH/$option ]
        then 
            # Funtion To Check The External Hard Drive Or Not
            backup_location Pycharm

            # Function To Start The Backup
            start_backup $PYCHARM_PROJECTS_PATH Pycharm
        else
            echo "The File You Entered Doesn't Excist"
        fi
        
        ;;


    # FLUTTER
    -f | --Flutter )
        # This Option is to Backup Flutter Projects By The Provided Project Name

        # Calling the function to list all files
        show_files $FLUTTER_PROJECTS_PATH
        
        # Check if the Entered File Name Excist First
        if [ -e $FLUTTER_PROJECTS_PATH/$option ]
        then 
            # Funtion To Check The External Hard Drive Or Not
            backup_location Flutter

            # Function To Start The Backup
            start_backup $FLUTTER_PROJECTS_PATH Flutter
        else
            echo "The File You Entered Doesn't Excist"
        fi
        
        ;;


    # DJANGO
    -d | --Django )
        # This Option is to Backup Django Projects By The Provided Project Name

        # Calling the function to list all files
        show_files $DJANGO_PROJECTS_PATH
        
        # Check if the Entered File Name Excist First
        if [ -e $DJANGO_PROJECTS_PATH/$option ]
        then 
            # Funtion To Check The External Hard Drive Or Not
            backup_location Django

            # Function To Start The Backup
            start_backup $DJANGO_PROJECTS_PATH Django
        else
            echo "The File You Entered Doesn't Excist"
        fi
        ;;


    # BASH SCRIPT
    -b | --Bash ) 
        show_files $BASH_SCRIPT_PATH

        # Check if the Entered File Name Excist First
        if [ -e $BASH_SCRIPT_PATH/$option ]
        then 
            # Check If The Backup Folder Already Created Or Not
            if [[ -d $LOCAL_BACKUP_PATH/"${MY_WORKSPACE_ARRAY[3]}"/$option || -e $BASH_SCRIPT_PATH/$option.zip ]]
            then
                echo ""
            else
                # Make A Directory With File Name And The Current Date To be Compressed
                mkdir -p $LOCAL_BACKUP_PATH/"${MY_WORKSPACE_ARRAY[3]}"/$option

                # Copy The File To The Created Directory To Be Compressed
                cp $BASH_SCRIPT_PATH/$option $LOCAL_BACKUP_PATH/"${MY_WORKSPACE_ARRAY[3]}"/$option/$option
            fi 

            # Funtion To Check The External Hard Drive Or Not
            backup_location Bash

            # Function To Start The Backup ******
            start_backup $LOCAL_BACKUP_PATH/"${MY_WORKSPACE_ARRAY[3]}"/$option Bash
        else
            echo "The File You Entered Doesn't Excist"
        fi

        ;;


    # -ed | --externalharddrive )  ****************************
    #     # Check if the backup drive is attached
    #     if [ -d $BACKUP_DRIVE_PATH ] 
    #     then
    #         for number in {0..3}
    #         do
    #             array_item=0
    #             check_backup $number $array_item
    #         done
    #     else
    #         echo "Sorry The External Back-Up Drive Is Not Detected"
    #     fi
    #     ;;


    # ANY OTHER OPTION
    * )
        echo ""
        echo "Sorry You Didn't Specify an Option"
        echo "-------------------------------------------------------------------------------"
        echo "1) Use -p or --Pycharm to Backup Pycharm Projrcts "
        echo "                  OR"
        echo "2) Use -f or --Flutter to Backup Flutter Projects "
        echo "                  OR"
        echo "3) Use -d or --Django to Backup Django Projects "
        echo ""
        echo "4) Use -b or --Bash to Backup Django Projects "
        echo ""
        # echo "5) Use -ed or --externalharddrive to Backup to the External Hard Drive "
        # echo ""
        ;;
esac

# Check If The User Want To Move Local To External
#####################################################################################################################################################################
if [[ $EXTERNAL_IS_ATTACHED == "True" ]]
then
    echo "We Are Detecting The External Back-Up Drive Is Attached!"
    read -p "Do You Want To Check If There Are Local Files Not In The External Drive(Y/N)? " user_input

    # Check The User Answer
    if [[ $user_input == "Y" || $user_input == "y" ]]
    then
        user_choice
    fi
fi
#####################################################################################################################################################################