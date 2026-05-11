import 'package:c_master/models/question_model.dart';

const List<Question> allQuestions = [

  // ── Introduction ─────────────────────────────────────────────────────────

  Question(
    topic: 'Introduction',
    question: 'Who developed the C programming language?',
    options: ['Bjarne Stroustrup', 'Dennis Ritchie', 'James Gosling', 'Guido van Rossum'],
    correctIndex: 1,
    explanation: 'C was developed by Dennis Ritchie at Bell Labs in 1972.',
  ),
  Question(
    topic: 'Introduction',
    question: 'C is classified as a _____ programming language.',
    options: ['High-level only', 'Low-level only', 'Middle-level', 'Machine-level'],
    correctIndex: 2,
    explanation: 'C is called a middle-level language because it bridges high-level and low-level features.',
  ),
  Question(
    topic: 'Introduction',
    question: 'Which header file is required for printf() and scanf()?',
    options: ['<stdlib.h>', '<string.h>', '<math.h>', '<stdio.h>'],
    correctIndex: 3,
    explanation: '<stdio.h> stands for Standard Input/Output and is needed for printf and scanf.',
  ),
  Question(
    topic: 'Introduction',
    question: 'What does the main() function return in C?',
    options: ['void', 'float', 'int', 'char'],
    correctIndex: 2,
    explanation: 'The main() function returns an int. Returning 0 typically signals success.',
  ),
  Question(
    topic: 'Introduction',
    question: 'Which of the following is a valid C comment syntax?',
    options: ['# This is a comment', '// This is a comment', '** This is a comment', '-- This is a comment'],
    correctIndex: 1,
    explanation: '// is the single-line comment syntax in C (and C++).',
  ),

  // ── Variables and Data Types ──────────────────────────────────────────────

  Question(
    topic: 'Variables and Data Types',
    question: 'Which is the correct way to declare an integer variable in C?',
    options: ['integer x;', 'int x;', 'Int x;', 'var x = 5;'],
    correctIndex: 1,
    explanation: 'C uses lowercase "int" to declare integer variables.',
  ),
  Question(
    topic: 'Variables and Data Types',
    question: 'What is the size of int on a 32-bit system?',
    options: ['1 byte', '2 bytes', '4 bytes', '8 bytes'],
    correctIndex: 2,
    explanation: 'On most 32-bit systems, int is 4 bytes (32 bits).',
  ),
  Question(
    topic: 'Variables and Data Types',
    question: 'Which data type stores a single character in C?',
    options: ['string', 'char', 'letter', 'str'],
    correctIndex: 1,
    explanation: 'The char data type stores a single character, using 1 byte.',
  ),
  Question(
    topic: 'Variables and Data Types',
    question: 'Which format specifier is used for float in printf()?',
    options: ['%d', '%c', '%s', '%f'],
    correctIndex: 3,
    explanation: '%f is the format specifier for float and double in printf().',
  ),
  Question(
    topic: 'Variables and Data Types',
    question: 'What is the output of: printf("%d", sizeof(char));',
    options: ['2', '4', '1', '8'],
    correctIndex: 2,
    explanation: 'sizeof(char) always returns 1 — a char is exactly 1 byte.',
  ),

  // ── Operators ─────────────────────────────────────────────────────────────

  Question(
    topic: 'Operators',
    question: 'What is the result of 10 % 3 in C?',
    options: ['3', '1', '0', '2'],
    correctIndex: 1,
    explanation: '% is the modulus operator. 10 % 3 = 1 (remainder when 10 is divided by 3).',
  ),
  Question(
    topic: 'Operators',
    question: 'Which operator is used for logical AND in C?',
    options: ['&', '&&', 'AND', '|'],
    correctIndex: 1,
    explanation: '&& is the logical AND operator. & is the bitwise AND operator.',
  ),
  Question(
    topic: 'Operators',
    question: 'What does the ++ operator do in C?',
    options: ['Decrements by 1', 'Multiplies by 2', 'Increments by 1', 'Divides by 2'],
    correctIndex: 2,
    explanation: '++ is the increment operator. It increases a variable\'s value by 1.',
  ),
  Question(
    topic: 'Operators',
    question: 'What is the output of: int x = 5; x += 3; printf("%d", x);',
    options: ['5', '3', '8', '15'],
    correctIndex: 2,
    explanation: '+= is compound assignment. x += 3 means x = x + 3, so 5 + 3 = 8.',
  ),
  Question(
    topic: 'Operators',
    question: 'Which of the following is a relational operator?',
    options: ['&&', '||', '>=', '++'],
    correctIndex: 2,
    explanation: '>= (greater than or equal) is a relational operator used to compare values.',
  ),

  // ── Control Flow ──────────────────────────────────────────────────────────

  Question(
    topic: 'Control Flow',
    question: 'Which loop always executes at least once?',
    options: ['for loop', 'while loop', 'do-while loop', 'None of the above'],
    correctIndex: 2,
    explanation: 'The do-while loop checks the condition AFTER executing the body, so it always runs at least once.',
  ),
  Question(
    topic: 'Control Flow',
    question: 'What keyword is used to skip the current iteration of a loop?',
    options: ['break', 'exit', 'skip', 'continue'],
    correctIndex: 3,
    explanation: 'continue skips the rest of the current loop iteration and moves to the next one.',
  ),
  Question(
    topic: 'Control Flow',
    question: 'What is the output of: for(int i=0; i<3; i++) printf("%d ", i);',
    options: ['1 2 3', '0 1 2', '0 1 2 3', '1 2'],
    correctIndex: 1,
    explanation: 'The loop starts at 0, increments while i < 3, printing 0, 1, 2.',
  ),
  Question(
    topic: 'Control Flow',
    question: 'Which statement transfers control out of a switch case?',
    options: ['exit()', 'return', 'break', 'continue'],
    correctIndex: 2,
    explanation: 'break is used in switch-case to prevent fall-through to the next case.',
  ),
  Question(
    topic: 'Control Flow',
    question: 'What is "fall-through" in a switch statement?',
    options: [
      'The program crashes',
      'Execution falls into the next case',
      'The default case runs first',
      'The switch repeats'
    ],
    correctIndex: 1,
    explanation: 'Without break, execution continues into the next case — this is called fall-through.',
  ),

  // ── Functions ─────────────────────────────────────────────────────────────

  Question(
    topic: 'Functions',
    question: 'What is a function prototype in C?',
    options: [
      'The function\'s full body',
      'A global variable',
      'A declaration of the function before its definition',
      'The return value'
    ],
    correctIndex: 2,
    explanation: 'A function prototype tells the compiler about the function\'s name, return type, and parameters before its actual definition.',
  ),
  Question(
    topic: 'Functions',
    question: 'What does a void function return?',
    options: ['0', 'NULL', 'Nothing', '-1'],
    correctIndex: 2,
    explanation: 'A void function doesn\'t return any value.',
  ),
  Question(
    topic: 'Functions',
    question: 'Call by value means:',
    options: [
      'The original variable is modified',
      'A copy of the argument is passed',
      'The function modifies the pointer',
      'No arguments are passed'
    ],
    correctIndex: 1,
    explanation: 'In call by value, a copy of the variable is passed; the original is not changed.',
  ),
  Question(
    topic: 'Functions',
    question: 'What is recursion in C?',
    options: [
      'A loop that runs infinitely',
      'A function calling itself',
      'A function with no parameters',
      'A pointer to a function'
    ],
    correctIndex: 1,
    explanation: 'Recursion is when a function calls itself. It must have a base case to terminate.',
  ),
  Question(
    topic: 'Functions',
    question: 'What is the return type of a function that returns nothing?',
    options: ['int', 'null', 'void', 'empty'],
    correctIndex: 2,
    explanation: 'Use "void" as the return type when a function doesn\'t return a value.',
  ),

  // ── Arrays and Strings ────────────────────────────────────────────────────

  Question(
    topic: 'Arrays and Strings',
    question: 'Array indices in C start from:',
    options: ['1', '-1', '0', 'Depends on compiler'],
    correctIndex: 2,
    explanation: 'Array indices in C (and most languages) start from 0.',
  ),
  Question(
    topic: 'Arrays and Strings',
    question: 'int arr[5]; — how many elements can this array hold?',
    options: ['4', '6', '5', 'Unlimited'],
    correctIndex: 2,
    explanation: 'int arr[5] declares an array with exactly 5 elements at indices 0 to 4.',
  ),
  Question(
    topic: 'Arrays and Strings',
    question: 'What terminates a string in C?',
    options: ['\\n', '\\0', '\\t', 'Space'],
    correctIndex: 1,
    explanation: 'Strings in C are null-terminated. \\0 is the null character marking the end.',
  ),
  Question(
    topic: 'Arrays and Strings',
    question: 'Which function is used to find string length in C?',
    options: ['sizeof()', 'length()', 'strlen()', 'strcount()'],
    correctIndex: 2,
    explanation: 'strlen() from <string.h> returns the length of a string (excluding \\0).',
  ),
  Question(
    topic: 'Arrays and Strings',
    question: 'What does strcpy(dest, src) do?',
    options: [
      'Compares two strings',
      'Concatenates strings',
      'Copies src string into dest',
      'Searches for a character'
    ],
    correctIndex: 2,
    explanation: 'strcpy() copies the source string into the destination buffer.',
  ),

  // ── Pointers ──────────────────────────────────────────────────────────────

  Question(
    topic: 'Pointers',
    question: 'What does the & operator do when used with a variable?',
    options: [
      'Dereferences the pointer',
      'Returns the value of the variable',
      'Returns the memory address of the variable',
      'Adds two variables'
    ],
    correctIndex: 2,
    explanation: '& is the address-of operator. It gives the memory address where a variable is stored.',
  ),
  Question(
    topic: 'Pointers',
    question: 'What does the * operator do when used with a pointer?',
    options: [
      'Multiplies values',
      'Gets the address',
      'Dereferences — accesses the value at that address',
      'Declares a new variable'
    ],
    correctIndex: 2,
    explanation: '* when used with a pointer is the dereference operator — it accesses the value at the pointer\'s address.',
  ),
  Question(
    topic: 'Pointers',
    question: 'What is a NULL pointer?',
    options: [
      'A pointer to 0 bytes of data',
      'A pointer that points to nothing (address 0)',
      'An uninitialized pointer',
      'A pointer to a null character'
    ],
    correctIndex: 1,
    explanation: 'A NULL pointer points to address 0 and represents "no valid address". Always initialize pointers.',
  ),
  Question(
    topic: 'Pointers',
    question: 'int *p; — what is p?',
    options: ['An integer', 'A pointer to an integer', 'An integer array', 'A function pointer'],
    correctIndex: 1,
    explanation: 'int *p declares p as a pointer to an integer. p stores a memory address.',
  ),
  Question(
    topic: 'Pointers',
    question: 'Pointer arithmetic: if int *p points to arr[0], what does p+1 point to?',
    options: ['arr[0] + 1', 'arr[2]', 'arr[1]', 'The next byte in memory'],
    correctIndex: 2,
    explanation: 'Pointer arithmetic with int* advances by sizeof(int) bytes, pointing to the next element arr[1].',
  ),

  // ── Structures ───────────────────────────────────────────────────────────

  Question(
    topic: 'Structures',
    question: 'What keyword is used to define a structure in C?',
    options: ['class', 'record', 'object', 'struct'],
    correctIndex: 3,
    explanation: '"struct" is the keyword used to define a structure in C.',
  ),
  Question(
    topic: 'Structures',
    question: 'How do you access a struct member using a pointer?',
    options: ['.', '::', '->', '*'],
    correctIndex: 2,
    explanation: 'Use the -> operator when accessing struct members through a pointer. Use . with a direct value.',
  ),
  Question(
    topic: 'Structures',
    question: 'What is the difference between struct and union in C?',
    options: [
      'No difference',
      'Union shares memory for all members; struct gives each member its own memory',
      'Struct shares memory; union does not',
      'Union is for integers only'
    ],
    correctIndex: 1,
    explanation: 'In a union, all members share the same memory location (size = largest member). Struct members have separate memory.',
  ),
  Question(
    topic: 'Structures',
    question: 'Can a struct contain another struct in C?',
    options: ['No', 'Yes, only with pointers', 'Yes, directly', 'Only in C++'],
    correctIndex: 2,
    explanation: 'Structs can be nested — a struct member can itself be another struct type.',
  ),
  Question(
    topic: 'Structures',
    question: 'What does "typedef struct" allow you to do?',
    options: [
      'Inherit from a struct',
      'Create a shorter alias for the struct type',
      'Make a struct private',
      'Define struct methods'
    ],
    correctIndex: 1,
    explanation: 'typedef allows you to create an alias so you can write "Point p;" instead of "struct Point p;".',
  ),
];

/// Returns questions for a specific topic
List<Question> questionsForTopic(String topic) =>
    allQuestions.where((q) => q.topic == topic).toList();

/// Returns all unique topic names that have questions
List<String> get quizTopics =>
    allQuestions.map((q) => q.topic).toSet().toList();
