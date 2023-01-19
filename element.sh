PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]
then
  if [[ ! $1 =~ ^[1-9][0-9]* ]]
  then
  ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1' OR symbol = '$1';")
    if [[ $ELEMENT_ID ]]
    
    then
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ELEMENT_ID;")
    else
      echo "I could not find that element in the database."
    fi
  else
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1;")
    if [[ ! $ELEMENT ]]
      
    then
      echo "I could not find that element in the database."
    fi
  fi
else
  echo "Please provide an element as an argument."
fi
if [[ $ELEMENT ]]
then
  if [[ $ELEMENT_ID ]]
  then
  ATOMICAL_ID=$ELEMENT_ID
  else
  ATOMICAL_ID=$1
  fi
fi
if [[ $ATOMICAL_ID ]]
then
MASA=$( cat ../atomic_mass.txt | grep "^$ATOMICAL_ID " | sed -r 's/^[1-9].* //')
    echo $ELEMENT | while IFS='|' read NUMBER SYMBOL NAME TYPE BAR MELTING BOILING
  do
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASA amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi
