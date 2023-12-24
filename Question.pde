class Question {
  int num1, num2;
  
  String [] operations = {" + ", " - ", " X ", " / "};  // Used to display questions
  
  int operation;  // operation index
  
  float correctAnswer;
  
  Question() {
  }
  
  void generateQuestion() {
    // First number is always greater than second (I'm avoiding negative and decimal answers)
    num1 = (int) random(1, 10);
    num2 = (int) random(1, num1 + 1);
    
    operation = (int) random(0, 4);    
    //operation = 0;    
    
    // Addition
    if (operation == 0) {
      correctAnswer = num1 + num2;
    }
    // Subtraction
    else if (operation == 1) {
      correctAnswer = num1 - num2;
    }
    // Multiplication
    else if (operation == 2) {
      correctAnswer = num1 * num2;
    }
    // Division
    else {
      correctAnswer = float(num1) / float(num2);
      
      // Make sure answer is a whole number, otherwise, regenerate question
      if (correctAnswer != round(correctAnswer)){
        generateQuestion();
      }
    }
    
  }
  
  // Returns question for displaying
  String getQuestion() {
    return Integer.toString(num1) + operations[operation] + Integer.toString(num2) + " = ";
  }
  
  // Check if given answer is correct
  boolean evaluate(int answer) {
    if (answer == correctAnswer) {
      return true;
    }
    return false;
  }
  
}
