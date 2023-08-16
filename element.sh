#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    INPUT_RESULT=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE atomic_number=$1")
  else
    INPUT_RESULT=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE name='$1' OR symbol='$1'")
  fi
  echo "$INPUT_RESULT" | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL
  do
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo -e "I could not find that element in the database."
  else
    echo "$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")" | while IFS='|' read TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
  done
else
  echo "Please provide an element as an argument."
fi
