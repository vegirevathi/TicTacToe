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

