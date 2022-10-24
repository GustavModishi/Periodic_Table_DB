#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
echo "Please provide an element as an argument."
else

VALUE=$1

if [[ ! $1 =~ ^[0-9]+$ ]]
then

RESULT=$($PSQL "SELECT e.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties p, elements e, types t WHERE e.atomic_number=p.atomic_number AND t.type_id=p.type_id AND e.atomic_number IN( SELECT atomic_number FROM elements WHERE name='$VALUE' OR symbol='$VALUE')")

else

RESULT=$($PSQL "SELECT e.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties p, elements e, types t WHERE e.atomic_number=p.atomic_number AND t.type_id=p.type_id AND e.atomic_number IN( SELECT atomic_number FROM elements WHERE atomic_number=$VALUE)")

fi
    
if [[ -z $RESULT ]]
then
echo -e "I could not find that element in the database."

else

echo "$RESULT" | while read AN BAR NAME BAR SYMBOL BAR TYPE BAR AM BAR MPC BAR BPC 
   do
    
    echo "The element with atomic number $AN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AM amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."

   done
fi

fi
