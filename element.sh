#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [ "$#" -eq 0 ]; then
  echo "Please provide an element as an argument."
else
  ATOMIC_NUMBER=$1
  SYMBOL=$1
  NAME=$1

  if [[ $ATOMIC_NUMBER =~ ^[0-9]+$ ]]; then
    ATOMIC_NUMBER=$1
  else
    ATOMIC_NUMBER=-1
  fi

  # check atomic number
  ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  # if no element available
  if [[ -z $ELEMENT ]]
  then
    # check for symbol
    ELEMENT=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$SYMBOL'")
    # if no element available
    if [[ -z $ELEMENT ]]
    then
      # check for name
      ELEMENT=$($PSQL "SELECT name FROM elements WHERE name = '$NAME'")
      # if no element available
      if [[ -z $ELEMENT ]]
      then
        # no element found
        echo I could not find that element in the database.
      else
        # get element data
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$NAME'")
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$NAME'")
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
        MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
        BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
        TYPE=$($PSQL "SELECT type FROM properties p INNER JOIN types t ON t.type_id = p.type_id WHERE atomic_number = $ATOMIC_NUMBER")
        echo -e "The element with atomic number $(echo $ATOMIC_NUMBER | xargs) is $(echo $NAME | xargs) ($(echo $SYMBOL | xargs)). It's a $(echo $TYPE | xargs), with a mass of $(echo $ATOMIC_MASS | xargs) amu. $(echo $NAME | xargs) has a melting point of $(echo $MELTING_POINT | xargs) celsius and a boiling point of $(echo $BOILING_POINT | xargs) celsius."
      fi
    else
      # get element data
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$SYMBOL'")
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL'")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      TYPE=$($PSQL "SELECT type FROM properties p INNER JOIN types t ON t.type_id = p.type_id WHERE atomic_number = $ATOMIC_NUMBER")
      echo -e "The element with atomic number $(echo $ATOMIC_NUMBER | xargs) is $(echo $NAME | xargs) ($(echo $SYMBOL | xargs)). It's a $(echo $TYPE | xargs), with a mass of $(echo $ATOMIC_MASS | xargs) amu. $(echo $NAME | xargs) has a melting point of $(echo $MELTING_POINT | xargs) celsius and a boiling point of $(echo $BOILING_POINT | xargs) celsius."
    fi
  else
    # get element data
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM properties p INNER JOIN types t ON t.type_id = p.type_id WHERE atomic_number = $ATOMIC_NUMBER")
    echo -e "The element with atomic number $(echo $ATOMIC_NUMBER | xargs) is $(echo $NAME | xargs) ($(echo $SYMBOL | xargs)). It's a $(echo $TYPE | xargs), with a mass of $(echo $ATOMIC_MASS | xargs) amu. $(echo $NAME | xargs) has a melting point of $(echo $MELTING_POINT | xargs) celsius and a boiling point of $(echo $BOILING_POINT | xargs) celsius."
  fi
fi
