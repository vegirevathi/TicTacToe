#!/bin/bash -x
echo "Welcome to Tic-Toe-Tac..Get Ready.."

gameBoard=(. . . . . . . . .)

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
