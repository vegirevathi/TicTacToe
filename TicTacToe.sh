#!/bin/bash 
echo "Welcome to Tic-Toe-Tac..Get Ready.."

function reset()
{
	Arr=(. . . . . . . . .)
	player=1
	gameStatus=1
}

function assignSymbol(){
	if [ $(( $RANDOM%2 )) -eq 1 ]
	then 
		playerSymbol=X
	else
		playerSymbol=O
	fi
	echo "Player Symbol is : " $playerSymbol
}
assignSymbol

function toss()
{
	read -p "Press 1 for HEADS or Press 2 for TAILS" playerSelection
	tossValue=$(( (( $RANDOM%2 ))+1 ))

	if [ $tossValue -eq $playerSelection ]
	then
		echo "player won the toss"
	else
		echo "player lost the toss"
	fi
}
toss

displayGameBoard()
{
	local row
	local column
	for (( row=1;row<=3;row++))
	do
		for (( column=1;column<=3;column++ ))
		do
			echo -n " ${board[$row,$column]}"
			if [ $column -ne 3 ]
			then
				echo -n " |"
			fi			
		done
		echo
		if [ $row -ne 3 ]
		then
		echo -n "_________"
		echo
		fi
	done
}
displayGameBoard

