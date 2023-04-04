#!/usr/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]];
then
  echo -e "Please provide an element as an argument."
else
  # script was ran with an argument
  ATOMNUM="^[0-9]{1,3}$"
  SYMBOL="^[a-Z]{1,2}$"
  NAME="^[a-Z]+$"
  if [[ $1 =~ $ATOMNUM ]];
  # if [[ $1 =~ ^[[:upper:]]{3}$ ]]; then
  then
    # atomic number
    ELE=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  elif [[ $1 =~ $SYMBOL ]];
  then
    # symbol
    ELE=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
  elif [[ $1 =~ $NAME ]];
  then
    # name
    ELE=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
  else
    echo "Invalid input."
  fi
  # $ELE will either be an atomic # or Null if value was filled
  if [[ -z $ELE ]];
  then
    echo "I could not find that element in the database."
  else
    QUERY=$($PSQL "select * from elements inner join properties on properties.atomic_number = elements.atomic_number inner join types on types.type_id = properties.type_id WHERE elements.atomic_number = $ELE;")
    IFS="|"
    echo "$QUERY" | (
      read num sym ename atomnum amass melting boiling typeid blank etype;
      echo "The element with atomic number $num is $ename ($sym). It's a $etype, with a mass of $amass amu. $ename has a melting point of $melting celsius and a boiling point of $boiling celsius."
    )
  fi
fi
