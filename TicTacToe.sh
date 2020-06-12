#!/bin/bash 
echo "Welcome to Tic-Toe-Tac..Get Ready.."

Arr=(. . . . . . . . .)

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
  echo "r\c 1 2 3"
  echo "1   ${Arr[0]} ${Arr[1]} ${Arr[2]}"
  echo "2   ${Arr[3]} ${Arr[4]} ${Arr[5]}"
  echo "3   ${Arr[6]} ${Arr[7]} ${Arr[8]}"
}
displayGameBoard
