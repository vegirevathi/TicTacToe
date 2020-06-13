#!/bin/bash 
echo "Welcome to Tic-Toe-Tac..Get Ready.."
function reset()
{
	player=2
	gameStatus=1
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
assignSymbol

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

function checkRow()
{
	row=$1
	rowFlag=1
	for (( column=1;column<3;column++ ))
	do
		if [ ${board[$row,$column]} != ${board[$row,$(($column+1))]} ] || [[ ${board[$row,$column]} = $SPACE ]]
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
		if [ ${board[$row,$column]} != ${board[$(($row+1)),$column]} ] || [[ ${board[$row,$column]} = $SPACE ]]
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
			if [ ${board[$row,$row]} != ${board[$(($row+1)),$(($row+1))]} ] || [[ ${board[$row,$column]} = $SPACE ]]
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
		if [ ${board[$row,$column]} != ${board[$(($row-1)),$(($column+1))]} ] || [[ ${board[$row,$column]} = $SPACE ]]
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
	rowEqual=$?
	column=$2
	checkColumn $column
	columnEqual=$?
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
			if [[ "${board[$row,$column]}" = $SPACE ]]
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
		echo "won"
	fi
	checkTie
	tie=$?
	if [ $tie -eq 1 ]
	then
		echo "tie"
	fi
	echo " next turn"
}
result=$(endResult 1 3)
echo $result

