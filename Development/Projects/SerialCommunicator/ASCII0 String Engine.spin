{{
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ASCII0 String Engine
//
// Author: Kwabena W. Agyeman
// Updated: 8/28/2010
// Designed For: P8X32A
// Version: 1.2
//
// Copyright (c) 2010 Kwabena W. Agyeman
// See end of file for terms of use.
//
// Update History:
//
// v1.0 - Original release - 4/10/2009.
// v1.1 - Made code faster - 8/18/2009.
// v1.2 - Updated library functions, fixed bugs, and made code more robust against whitespace and capitalization - 7/27/2010.
//
// For each included copy of this object only one spin interpreter should access it at a time.
//
// Nyamekye,
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}}

VAR

  word tokenStringPointer
  byte decimalString[12], hexadecimalString[9], binaryString[33], characterToStringPointer, characterToString[255]

PUB buildString(character) '' 4 Stack longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Builds a string from individual characters. Use "builtString" to get the address of the string.
'' //
'' // If the backspace character is put into the string it is automatically evaluated by removing the previous character.
'' //
'' // If 254 characters are put into the string all characters excluding backspace that are put into the string are ignored.
'' //
'' // Character - The next character to include in the string. Null will be ignored.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ifnot(characterToStringPointer)
    bytefill(@characterToString, 0, 255)

  if(characterToStringPointer and (character == 8))
    characterToString[--characterToStringPointer] := 0

  elseif(character and (characterToStringPointer <> 254))
    characterToString[characterToStringPointer++] := character

PUB builtString(resetString) '' 4 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Returns the pointer to the string built from individual characters.
'' //
'' // Reset - If true the next call to "buildString" will begin building a new string and the old string will be destroyed.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  characterToStringPointer &= not(resetString)
  return @characterToString

PUB builderNumber '' 3 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Returns the number of characters in the string builder buffer.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  return characterToStringPointer

PUB builderFull '' 3 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Returns true if the string builder buffer is full and false if not.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  return (characterToStringPointer == 254)

PUB stringCompareCS(characters, otherCharacters) '' 5 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Compares two strings case sensitively.
'' //
'' // Returns zero if the two strings are equal.
'' // Returns a positive value if "characters" comes lexicographically after "otherCharacters".
'' // Returns a negative value if "characters" comes lexicographically before "otherCharacters".
'' //
'' // Characters - A pointer to a string of characters.
'' // OtherCharacters - A pointer to another string of characters.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  repeat
    result := (byte[characters] - byte[otherCharacters++])
  while(byte[characters++] and (not(result)))

PUB stringCompareCI(characters, otherCharacters) '' 9 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Compares two strings case insensitively.
'' //
'' // Returns zero if the two strings are equal.
'' // Returns a positive value if "characters" comes lexicographically after "otherCharacters".
'' // Returns a negative value if "characters" comes lexicographically before "otherCharacters".
'' //
'' // Characters - A pointer to a string of characters.
'' // OtherCharacters - A pointer to another string of characters.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  repeat
    result := (ignoreCase(byte[characters]) - ignoreCase(byte[otherCharacters++]))
  while(byte[characters++] and (not(result)))

PUB stringCopy(whereToPut, whereToGet) '' 5 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Copies a string from one location to another. This method can corrupt memory.
'' //
'' // Returns a pointer to the new string.
'' //
'' // WhereToPut - Address of where to put the copied string.
'' // WhereToGet - Address of where to get the string to copy.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  bytemove(whereToPut, whereToGet, (strsize(whereToGet) + 1))
  return whereToPut

PUB stringConcatenate(whereToPut, whereToGet) '' 5 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Concatenates a string onto the end of another. This method can corrupt memory.
'' //
'' // Returns a pointer to the new string.
'' //
'' // WhereToPut - Address of the string to concatenate a string to.
'' // WhereToGet - Address of where to get the string to concatenate.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  bytemove((whereToPut + strsize(whereToPut)), whereToGet, (strsize(whereToGet) + 1))
  return whereToPut

PUB stringToLowerCase(characters) '' 4 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Demotes all upper case characters in the set of ("A","Z") to their lower case equivalents.
'' //
'' // Characters - A pointer to a string of characters to convert to lowercase.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  repeat strsize(characters--)
    result := byte[++characters]
    if((result => "A") and (result =< "Z"))
      byte[characters] := (result + 32)

PUB stringToUpperCase(characters) '' 4 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Promotes all lower case characters in the set of ("a","z") to their upper case equivalents.
'' //
'' // Characters - A pointer to a string of characters to convert to uppercase.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  repeat strsize(characters--)
    result := byte[++characters]
    if((result => "a") and (result =< "z"))
      byte[characters] := (result - 32)

PUB trimString(characters) '' 8 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Removes white space and new lines arround the outside of string of characters.
'' //
'' // Returns a pointer to the trimmed string of characters.
'' //
'' // Characters - A pointer to a string of characters to be trimmed.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  result := ignoreSpace(characters)
  characters := (result + ((strsize(result) - 1) #> 0))

  repeat
    case byte[characters]
      8 .. 13, 32, 127: byte[characters--] := 0
      other: quit

PUB tokenizeString(characters) '' 8 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Removes white space and new lines arround the inside of a string of characters.
'' //
'' // Returns a pointer to the tokenized string of characters, or an empty string when out of tokenized strings of characters.
'' //
'' // Characters - A pointer to a string of characters to be tokenized, or null to continue tokenizing a string of characters.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if(characters)
    tokenStringPointer := characters

  result := tokenStringPointer := ignoreSpace(tokenStringPointer)

  repeat while(byte[tokenStringPointer])
    case byte[tokenStringPointer++]
      8 .. 13, 32, 127:
        byte[tokenStringPointer - 1] := 0
        quit

PUB findCharacter(stringToSearch, characterToFind) '' 5 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Searches a string of characters for the first occurence of the specified character.
'' //
'' // Returns the address of that character if found and zero if not found.
'' //
'' // StringToSearch - A pointer to the string of characters to search.
'' // CharacterToFind - The character to find in the string of characters to search.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  repeat strsize(stringToSearch--)
    if(byte[++stringToSearch] == characterToFind)
      return stringToSearch

PUB replaceCharacter(stringToSearch, characterToReplace, characterToReplaceWith) '' 11 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Replaces the first occurence of the specified character in a string of characters with another character.
'' //
'' // Returns the address of the next character after the character replaced on success and zero on failure.
'' //
'' // StringToSearch - A pointer to the string of characters to search.
'' // CharacterToReplace - The character to find in the string of characters to search.
'' // CharacterToReplaceWith - The character to replace the character found in the string of characters to search.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  result := findCharacter(stringToSearch, characterToReplace)
  if(result)
    byte[result++] := characterToReplaceWith

PUB replaceAllCharacters(stringToSearch, characterToReplace, characterToReplaceWith) '' 17 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Replaces all occurences of the specified character in a string of characters with another character.
'' //
'' // StringToSearch - A pointer to the string of characters to search.
'' // CharacterToReplace - The character to find in the string of characters to search.
'' // CharacterToReplaceWith - The character to replace the character found in the string of characters to search.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  repeat while(stringToSearch)
    stringToSearch := replaceCharacter(stringToSearch, characterToReplace, characterToReplaceWith)

PUB findString(stringToSearch, stringToFind) | index, size '' 7 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Searches a string of characters for the first occurence of the specified string of characters.
'' //
'' // Returns the address of that string of characters if found and zero if not found.
'' //
'' // StringToSearch - A pointer to the string of characters to search.
'' // StringToFind - A pointer to the string of characters to find in the string of characters to search.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  size := strsize(stringToFind)
  if(size--)

    repeat strsize(stringToSearch--)
      if(byte[++stringToSearch] == byte[stringToFind])

        repeat index from 0 to size
          if(byte[stringToSearch][index] <> byte[stringToFind][index])
            result := true
            quit

        ifnot(result~)
          return stringToSearch

PUB replaceString(stringToSearch, stringToReplace, stringToReplaceWith) '' 13 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Replaces the first occurence of the specified string of characters in a string of characters with another string of
'' // characters. Will not enlarge or shrink a string of characters.
'' //
'' // Returns the address of the next character after the string of characters replaced on success and zero on failure.
'' //
'' // StringToSearch - A pointer to the string of characters to search.
'' // StringToReplace - A pointer to the string of characters to find in the string of characters to search.
'' // StringToReplaceWith - A pointer to the string of characters that will replace the string of characters found in the
'' //                       string of characters to search.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  result := findString(stringToSearch, stringToReplace)
  if(result)

    repeat (strsize(stringToReplaceWith) <# strsize(stringToReplace))
      byte[result++] := byte[stringToReplaceWith++]

PUB replaceAllStrings(stringToSearch, stringToReplace, stringToReplaceWith) '' 19 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Replaces all occurences of the specified string of characters in a string of characters with another string of
'' // characters. Will not enlarge or shrink a string of characters.
'' //
'' // StringToSearch - A pointer to the string of characters to search.
'' // StringToReplace - A pointer to the string of characters to find in the string of characters to search.
'' // StringToReplaceWith - A pointer to the string of characters that will replace the string of characters found in the
'' //                       string of characters to search.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  repeat while(stringToSearch)
    stringToSearch := replaceString(stringToSearch, stringToReplace, stringToReplaceWith)

PUB integerToDecimal(number, length) '' 5 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Converts an integer number to the decimal string of that number padded with zeros.
'' //
'' // Returns a pointer to the converted string.
'' //
'' // Number - A 32 bit signed integer number to be converted to a string.
'' // Length - The length of the converted string, "+" or "-" will be concatenated onto the head of converted string.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  length := (10 - ((length <# 10) #> 0))

  decimalString := "+"
  if(number < 0)
    decimalString := "-"

  if(number == negx)
    bytemove(@decimalString, string("-2147483648KA"), 11)

  else
    repeat result from 10 to 1
      decimalString[result] := ((||(number // 10)) + "0")
      number /= 10

  decimalString[length] := decimalString
  return @decimalString[length]

PUB integerToHexadecimal(number, length) '' 5 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Converts an integer number to the hexadecimal string of that number padded with zeros.
'' //
'' // Returns a pointer to the converted string.
'' //
'' // Number - A 32 bit signed integer number to be converted to a string.
'' // Length - The length of the converted string, negative numbers need a length of 8 for sign extension.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  repeat result from 7 to 0
    hexadecimalString[result] := lookupz((number & $F): "0".."9", "A".."F")
    number >>= 4

  return @hexadecimalString[8 - ((length <# 8) #> 0)]

PUB integerToBinary(number, length) '' 5 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Converts an integer number to the binary string of that number padded with zeros.
'' //
'' // Returns a pointer to the converted string.
'' //
'' // Number - A 32 bit signed integer number to be converted to a string.
'' // Length - The length of the converted string, negative numbers need a length of 32 for sign extension.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  repeat result from 31 to 0
    binaryString[result] := ((number & 1) + "0")
    number >>= 1

  return @binaryString[32 - ((length <# 32) #> 0)]

PUB decimalToInteger(characters) | sign '' 10 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Converts a decimal string into an integer number. Expects a string with only "+-0123456789" characters.
'' //
'' // If the string has a "-" sign as its leading character the converted integer returned will be negated.
'' //
'' // If the string has a "+" sign as its leading character the converted integer returned will not be negated.
'' //
'' // Returns the converted integer. By default the number returned is positive and the "+" sign is unnecessary.
'' //
'' // Characters - A pointer to the decimal string to convert. The number returned will be 2's complement compatible.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  characters := checkSign(ignoreSpace(characters), @sign)

  repeat (strsize(characters) <# 10)
    ifnot(checkDigit(characters, "0", "9"))
      quit

    result := ((result * 10) + (byte[characters++] & $F))
  result *= sign

PUB hexadecimalToInteger(characters) | sign '' 10 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Converts a hexadecimal string into an integer number. Expects a string with only "+-0123456789ABCDEFabdcef" characters.
'' //
'' // If the string has a "-" sign as its leading character the converted integer returned will be negated.
'' //
'' // If the string has a "+" sign as its leading character the converted integer returned will not be negated.
'' //
'' // Returns the converted integer. By default the number returned is positive and the "+" sign is unnecessary.
'' //
'' // Characters - A pointer to the hexadecimal string to convert. The number returned will be 2's complement compatible.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  characters := checkSign(ignoreSpace(characters), @sign)

  repeat (strsize(characters) <# 8)
    ifnot(checkDigit(characters, "0", "9"))
      ifnot(checkDigit(characters, "A", "F") or checkDigit(characters, "a", "f"))
        quit

      result += $90_00_00_00
    result := ((result <- 4) + (byte[characters++] & $F))
  result *= sign

PUB binaryToInteger(characters) | sign '' 10 Stack Longs

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Converts a binary string into an integer number. Expects a string with only "+-01" characters.
'' //
'' // If the string has a "-" sign as its leading character the converted integer returned will be negated.
'' //
'' // If the string has a "+" sign as its leading character the converted integer returned will not be negated.
'' //
'' // Returns the converted integer. By default the number returned is positive and the "+" sign is unnecessary.
'' //
'' // Characters - A pointer to the binary string to convert. The number returned will be 2's complement compatible.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  characters := checkSign(ignoreSpace(characters), @sign)

  repeat (strsize(characters) <# 32)
    ifnot(checkDigit(characters, "0", "1"))
      quit

    result := ((result << 1) + (byte[characters++] & 1))
  result *= sign

PRI ignoreCase(character) ' 4 Stack Longs

  result := character
  if((character => "a") and (character =< "z"))
    result -= 32

PRI ignoreSpace(characters) ' 4 Stack Longs

  result := characters
  repeat strsize(characters--)
    case byte[++characters]
      8 .. 13, 32, 127:
      other: return characters

PRI checkSign(characters, signAddress) ' 5 Stack Longs

  if(byte[characters] == "-")
    result := -1

  if(byte[characters] == "+")
    result := 1

  long[signAddress] := (result + ((not(result)) & 1))
  return (characters + (||result))

PRI checkDigit(characters, low, high) ' 5 Stack Longs

  result := byte[characters]
  return ((low =< result) and (result =< high))

{{

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  TERMS OF USE: MIT License
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}}