#!/bin/bash 
echo "Welcome to Tic-Toe-Tac..Get Ready.."

declare -A board
TRUE=1
FALSE=0
WON=1
TIE=2
TURN=3

function reset()
{
	for (( row=1;row<=3;row++))
	do
		for (( column=1;column<=3;column++ ))
		do
			board[$row,$column]='.'
		done
	done
}

function assignSymbol(){
	if [ $(( $RANDOM%2 )) -eq 1 ]
	then 
		playerSymbol=X
		computerSymbol=0
	else
		playerSymbol=O
		computerSymbol=X
	fi
	echo "Player Symbol is : " $playerSymbol
	echo "Computer Symbol is : " $computerSymbol
}

function toss()
{
	read -p "Press 1 for HEADS or Press 2 for TAILS" playerSelection
	tossValue=$(($RANDOM%2))

	if [ $tossValue -eq $playerSelection ]
	then
		echo "player won the toss. Player plays first"
	else
		echo "Computer won the toss. Computer plays first"
	fi
}

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
			echo -n "_____________"
			echo
		fi
	done
}

function fillCellsInBoard()
{
	row=$1
	column=$2
	symbol=$3
	if [ ${board[$row,$column]} = '.' ]
	then
		board[$row,$column]=$symbol
		return 1
	fi
	return 0
}

function checkRow()
{
	row=$1
	rowFlag=$TRUE
	for (( column=1;column<3;column++ ))
	do
		if [[ ${board[$row,$column]} != ${board[$row,$(($column+1))]} ]] || [[ ${board[$row,$column]} = '.' ]]
		then
			rowFlag=$FALSE
			break
		fi
	done
	echo $rowFlag
}

function checkColumn()
{
	column=$1
	columnFlag=$TRUE
	for (( row=1;row<3;row++ ))
	do
		if [ ${board[$row,$column]} != ${board[$(($row+1)),$column]} ] || [[ ${board[$row,$column]} = '.' ]]
		then
			columnFlag=$FALSE
			break
		fi
	done
	echo $columnFlag
}

function checkDiagonal()
{
	local row
	local column
	local checkDiagonal1=$TRUE
	local checkDiagonal2=$TRUE
	
	for (( row=1,column=3;row<3;row++,column-- ))
	do
		if [[ ${board[$row,$row]} != ${board[$(($row+1)),$(($row+1))]} ]] || [ ${board[$row,$row]} = '.' ]
		then
			checkDiagonal1=$FALSE
		fi
		if [[ ${board[$row,$column]} != ${board[$(($row+1)),$(($column-1))]} ]] || [ ${board[$row,$column]} = '.' ]
		then
			checkDiagonal2=$FALSE
		fi		
	done	
	
	if [ $checkDiagonal1 -eq $TRUE -o $checkDiagonal2 -eq $TRUE ]
	then
		return $TRUE
	else
		return $FALSE
	fi
}

function checkWin()
{
	row=$1
	rowEqual=$(checkRow $row)
	column=$2
	columnEqual=$(checkColumn $column)
	checkDiagonal
	diagonalEqual=$?

	if [ $rowEqual -eq $TRUE -o $columnEqual -eq $TRUE -o $diagonalEqual -eq $TRUE ]
	then
		return $TRUE
	else
		return $FALSE
	fi
}

function checkTie()
{
	for (( row=1;row<=3;row++ ))
	do
		for (( column=1;column<=3;column++ ))
		do
			if [[ "${board[$row,$column]}" = '.' ]]
			then
				return $FALSE
			fi
		done
	done
	return $TRUE
}

function endResult()
{
	local row=$1
	local column=$2
	checkWin $row $column
	if [ $? -eq $TRUE ]
	then
		return $WON
	fi
	checkTie
	if [ $? -eq $TRUE ]
	then
		return $TIE
	fi
	return $TURN
}

function computer()
{
	checkSymbol=$1
	replaceSymbol=$2
	for (( row=1;row<=3;row++ ))
	do
		for (( column=1;column<=3;column++ ))
		do
			if [ ${board[$row,$column]} = '.' ]
			then		
				board[$row,$column]=$checkSymbol
				checkWin $row $column
				local win=$?
				if [ $? -eq $TRUE ]
				then
					board[$row,$column]=$replaceSymbol
					return $TRUE
				else
					board[$row,$column]='.'
				fi
			fi
		done
	done
	return $FALSE
}

function occupyCorners()
{
	for (( row=1;row<=3;row+2 ))
	do
		for (( column=1;column<=3;column+2 ))
		do
			fillCellsInBoard $row $column $computerSymbol
			if [ $? -eq $TRUE ]
			then
				return $TRUE
			fi
		done
	done
	return $FALSE
}

function occupyCenter()
{
	row=2
	column=2
	if [ ${board[$row,$column]} = '.' ]
	then
		board[$row,$column]=$computerSymbol
		return $TRUE
	fi
	return $FALSE
}

function occupySide()
{
	for (( row=1;row<=3;row++ ))
	do
		for (( column=1;column<=3;column++ ))
		do
			if { [ $row -eq 1 ] || [ $row -eq 3 ] ;} && [ $column -ne 1 -a $column -ne 3 ] 
			then
				if [ ${board[$row,$column]} = '.' ]
				then
					board[$row,$column]=$computerSymbol
				return $TRUE
				fi 	
			fi
			
			if { [ $column -eq 1 ] || [ $column -eq 3 ] ;} && [ $row -ne 1 -a $row -ne 3 ] 
			then
				if [ ${board[$row,$column]} = '.' ]
				then
					board[$row,$column]=$computerSymbol
				return $TRUE
				fi 	
			fi
		done
	done
}

function playerTurn()
{
	playerSymbol=$1
	filled=$FALSE
	while [ $filled -eq $FALSE ]
	do
		read -p "Enter Row" row
		read -p "Enter Column" column
		fillCellsInBoard $row $column $playerSymbol
		filled=$?
	done
	endResult $row $column
	result=$?
	if [ $result = $WON ]
	then
		echo "Player Won the Game"
		return $TRUE
	elif [ $result = $TIE ]
	then
		echo "Game is draw"
		return $TRUE
	else
		return $FALSE
	fi
}

function computerTurn()
{
	local filled=0
	computer $computerSymbol $computerSymbol
	if [ $? -eq $TRUE ]
	then
		#echo "Computer Won the Game"
		return $TRUE
	fi
	computer $playerSymbol $computerSymbol
	if [ $? -eq $TRUE ]
	then
		return $FALSE
	fi
	occupyCorners
	if [ $? -eq $TRUE ]
	then
		return $FALSE
	fi
	occupyCenter
   if [ $? -eq $TRUE ]
   then
      return $FALSE
   fi
	occupySide
   if [ $? -eq $TRUE ]
   then
      return $FALSE
   fi
}

switchPlayer(){
	local computer=$1
	local player=$((1-$computer))
	if [ $player -eq 1 ]
	then
		playerTurn
		displayGameBoard
	else
		computerTurn
		displayGameBoard
	fi
}

function getSymbolForPlayer {

	if [ $((RANDOM%2)) -eq 1 ]
	then
		echo "X O"
	else
		echo "O X"
	fi
}

function gamePlay()
{
	reset
	assignSymbol
	toss
	displayGameBoard
	local exit1
	chance=$((RANDOM%2))
	quit=$FALSE
	while [ $FALSE -eq $quit ]
	do	
		if [[ $chance -eq $FALSE ]]
		then
			chance=$TRUE
			playerTurn $playerSymbol
			quit=$?
		else
			chance=$FALSE
			computerTurn	
			if [ $? -eq $FALSE ]
			then
				checkTie
				if [ $? -eq $TRUE ]
				then
			     		echo "tie"
					quit=$TRUE		
				fi
			else
				quit=$TRUE
			fi
		fi
		displayGameBoard
		echo
	done
}

gamePlay
