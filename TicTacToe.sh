#!/bin/bash 
echo "Welcome to Tic-Toe-Tac..Get Ready.."

declare -A board

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
#reset

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
#assignSymbol

function toss()
{
	read -p "Press 1 for HEADS or Press 2 for TAILS" playerSelection
	tossValue=$(( (( $RANDOM%2 ))+1 ))

	if [ $tossValue -eq $playerSelection ]
	then
		echo "player won the toss. Player plays first"
	else
		echo "Computer won the toss. Computer plays first"
	fi
}
#toss

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
#displayGameBoard

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
	rowFlag=1
	for (( column=1;column<3;column++ ))
	do
		if [[ ${board[$row,$column]} != ${board[$row,$(($column+1))]} ]] || [[ ${board[$row,$column]} = '.' ]]
		then
			rowFlag=0
			break
		fi
	done
	return $rowFlag
}

function checkColumn()
{
	column=$1
	columnFlag=1
	for (( row=1;row<3;row++ ))
	do
		if [ ${board[$row,$column]} != ${board[$(($row+1)),$column]} ] || [[ ${board[$row,$column]} = '.' ]]
		then
			columnFlag=0
			break
		fi
	done
	return $columnFlag
}

function checkDiagonalOne()
{
	row=$1
	column=$2
	diagonalFlag=1
	if [ $row -eq $column ]
	then
		for (( row=1;row<3;row++ ))
		do
			if [ ${board[$row,$row]} != ${board[$(($row+1)),$(($row+1))]} ] || [[ ${board[$row,$column]} = '.' ]]
			then
				diagonalFlag=0
				break
			fi	
		done
	else
		return 0
	fi
	return $diagonalFlag
}

function checkDiagonalTwo()
{
	diagonalFlag=1
	for (( row=3,column=1;row>1;row--,column++ ))
	do
		if [ ${board[$row,$column]} != ${board[$(($row-1)),$(($column+1))]} ] || [[ ${board[$row,$column]} = '.' ]]
			then
				diagonalFlag=0
				break
			fi		
	done
	return $diagonalFlag
}

function checkWin()
{
	row=$1
	checkRow $row
	rowEqual=$row
	column=$2
	checkColumn $column
	columnEqual=$column
	checkDiagonalOne $row $column
	diagonalOneEqual=$?
	checkDiagonalTwo
	diagonalTwoEqual=$?

	if [ $rowEqual -eq 1 -o $columnEqual -eq 1 -o $diagonalOneEqual -eq 1 -o $diagonalTwoEqual -eq 1 ]
	then
		return 1
	else
		return 0
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
				return 0
			fi
		done
	done
	return 1
}

function endResult()
{
	local row=$1
	local column=$2
	checkWin $row $column
	win=$?
	if [ $win -eq 1 ]
	then
		return $WON
	fi
	checkTie
	tie=$?
	if [ $tie -eq 1 ]
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
				if [ $win -eq 1 ]
				then
					board[$row,$column]=$replaceSymbol
					return 1
				else
					board[$row,$column]='.'
				fi
			fi
		done
	done
	return 0
}

function occupyCorners()
{
	for (( row=1;row<=3;row+2 ))
	do		for (( column=1;column<=3;column+2 ))
		do
			fillCellsInBoard $row $column $computerSymbol
			if [ $? -eq 1 ]
			then
				return 1
			fi
		done
	done
	return 0
}

function occupyCenter()
{
	row=2
	column=2
	if [ ${board[$row,$column]} = '.' ]
	then
		board[$row,$column]=$computerSymbol
		return 1
	fi
	return 0
}

function occupySide()
{
	for (( row=1;row<=3;row++ ))
	do
		for (( column=1;column<=3;column++ ))
		do
			if [ $(( $row-$column )) -eq 1 ] || [ $(( $column-$row )) -eq 1 ]
			then
				if [ ${board[$row,$column]} = '.' ]
				then
					board[$row,$column]=$computerSymbol
					return 1
				fi
			fi
		done
	done
	return 0
}

function playerTurn()
{
	playerSymbol=$1
	filled=0
	while [ $filled -eq 0 ]
	do
		read -p "Enter Row" row
		read -p "Enter Column" column
		fillCellsInBoard $row $column $playerSymbol
		filled=$?
	done
	endResult $row $column
	result=$?
	if [ $result = "WON" ]
	then
		echo "Player Won the Game"
		return 1
	elif [ $result = $TIE ]
	then
		echo "Game is draw"
		return 1
	else
		return 0
	fi
}

function computerTurn()
{
	local filled=0
	computer $computerSymbol $computerSymbol
	if [ $? -eq 1 ]
	then
		return 1
	fi
	computer $playerSymbol $computerSymbol
	if [ $? -eq 1 ]
	then
		return 0
	fi
	occupyCorners
	if [ $? -eq 1 ]
	then
		return 0
	fi
	occupyCenter
   if [ $? -eq 1 ]
   then
      return 0
   fi
	occupySide
   if [ $? -eq 1 ]
   then
      return 0
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
	quit=0
	while [ 0 -eq 0 ]
	do
		if [ $chance -eq 0 ]
		then
			chance=1
			#echo "Player Won the Toss. Player plays First."
			playerTurn $playerSymbol
			quit=$?
		else
			chance=0
			computerTurn
			if [ $? -eq 0 ]
			then
				checkTie
				if [ $? -eq 1 ]
				then
					echo "tie"
					quit=1
				fi
			else
				quit=1
			fi
		fi
		displayGameBoard
		echo
	done
}

gamePlay
