#!/bin/bash

# 텍스트 파일 경로
file_path="/usr/syno/synoman/webman/modules/StorageManager/storage_panel.js"

# 가능한 스토리지 모양들
storage_options=(
    "RACK_0_Bay" "RACK_2_Bay" "RACK_4_Bay" "RACK_8_Bay" "RACK_10_Bay"
    "RACK_12_Bay" "RACK_12_Bay_2" "RACK_16_Bay" "RACK_20_Bay" "RACK_24_Bay"
    "RACK_60_Bay" "TOWER_1_Bay" "TOWER_2_Bay" "TOWER_4_Bay" "TOWER_4_Bay_J"
    "TOWER_4_Bay_S" "TOWER_5_Bay" "TOWER_6_Bay" "TOWER_8_Bay" "TOWER_12_Bay"
)

if [ $# -eq 0 ]; then
    while true; do
        clear  # 이전 메뉴 출력 지우기

        echo "=== 현재 스토리지 모양을 선택 ==="
        for ((i = 0; i < ${#storage_options[@]}; i++)); do
            echo "$(($i + 1)). ${storage_options[$i]}"
        done
        echo "0. 프로그램 종료"
        echo "============"

        read -p "원하는 옵션을 선택하세요: " choice

        case $choice in
            0)
                echo "프로그램을 종료합니다."
                break
                ;;
            [1-9]|1[0-9]|20)
                clear
                echo "=== 바꿀 스토리지 모양을 선택 ==="
                for ((i = 0; i < ${#storage_options[@]}; i++)); do
                    echo "$(($i + 1)). ${storage_options[$i]}"
                done
                echo "0. 이전 메뉴로 돌아가기"
                echo "============"

                read -p "원하는 옵션을 선택하세요: " sub_choice

                case $sub_choice in
                    0)
                        echo "서브 메뉴를 종료합니다."
                        ;;
                    [1-9]|1[0-9]|20)
                        echo "옵션 1을 선택했습니다."
                        # text1과 text2를 서로 바꾸는 작업
                        sed -i "s/${storage_options[sub_choice - 1]}:\[/tempmp/g" "$file_path"
                        sed -i "s/${storage_options[choice - 1]}:\[/${storage_options[sub_choice - 1]}:\[/g" "$file_path"
                        sed -i "s/tempmp/${storage_options[choice - 1]}:\[/g" "$file_path"

                        # 작업 수행 (sed 및 gzip 등)
                        gzip $file_path -k -f
                        ;;
                    *)
                        echo "잘못된 선택입니다. 다시 선택해주세요."
                        ;;
                esac
                ;;
            *)
                echo "잘못된 선택입니다. 다시 선택해주세요."
                ;;
        esac
    done
elif [ $# -eq 1 ]; then
    echo "매개변수가 1개인 경우입니다."
    echo "매개변수 1: $1"
elif [ $# -eq 2 ]; then
    param1_found=false
    param2_found=false

    for option in "${storage_options[@]}"; do
        if [ "$option" = "$1" ]; then
            param1_found=true
        fi
        if [ "$option" = "$2" ]; then
            param2_found=true
        fi
    done

    if [ "$param1_found" = true ] && [ "$param2_found" = true ]; then
        # text1과 text2를 서로 바꾸는 작업
        sed -i "s/$2:\[/tempmp/g" "$file_path"
        sed -i "s/$1:\[/$2:\[/g" "$file_path"
        sed -i "s/tempmp/$1:\[/g" "$file_path"

        # 작업 수행 (sed 및 gzip 등)
        gzip $file_path -k -f
    else
        echo "두 개의 매개변수 중 적어도 하나가 변수 목록에 포함되지 않습니다."
    fi
else
    echo "매개변수가 3개 이상인 경우입니다."
fi
