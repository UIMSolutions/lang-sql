module langs.sql.sqlparsers.processors.index;

import lang.sql;

@safe:

// This class processes the INDEX statements.
class IndexProcessor : AbstractProcessor {

  auto process(mytokens) {

    string myCurrentCategory = "INDEX_NAME";
    auto result = ["base_expr": false, "name": false, "no_quotes": false, "index-type": false, "on": false, "options": []];
    auto myExpression = [];
    baseExpression = "";
    myskip = 0;

    foreach (mytokenKey : myToken; mytokens) {
      auto strippedToken = myToken.strip;
      baseExpression ~= myToken;

      if (myskip > 0) {
        myskip--;
        continue;
      }

      if (myskip < 0) {
        break;
      }

      if (strippedToken.isEmpty) {
        continue;
      }

      upperToken = strippedToken.toUpper;
      switch (upperToken) {

      case "USING" : if (myprevCategory == "CREATE_DEF") {
         myExpression ~= this.getReservedType(strippedToken);
         myCurrentCategory = "TYPE_OPTION";
          continue 2;
        }
        if (myprevCategory == "TYPE_DEF") {
         myExpression ~= this.getReservedType(strippedToken);
         myCurrentCategory = "INDEX_TYPE";
          continue 2;
        }
        // else ?
        break;

      case "KEY_BLOCK_SIZE" : if (myprevCategory == "CREATE_DEF") {
         myExpression ~= this.getReservedType(strippedToken);
         myCurrentCategory = "INDEX_OPTION";
          continue 2;
        }
        // else ?
        break;

      case "WITH" : if (myprevCategory == "CREATE_DEF") {
         myExpression ~= this.getReservedType(strippedToken);
         myCurrentCategory = "INDEX_PARSER";
          continue 2;
        }
        // else ?
        break;

      case "PARSER" : if (myCurrentCategory == "INDEX_PARSER") {
         myExpression ~= this.getReservedType(strippedToken);
          continue 2;
        }
        // else ?
        break;

      case "COMMENT" : if (myprevCategory == "CREATE_DEF") {
         myExpression ~= this.getReservedType(strippedToken);
         myCurrentCategory = "INDEX_COMMENT";
          continue 2;
        }
        // else ?
        break;

      case "ALGORITHM" : case "LOCK" : if (myprevCategory == "CREATE_DEF") {
         myExpression ~= this.getReservedType(strippedToken);
         myCurrentCategory = upperToken."_OPTION";
          continue 2;
        }
        // else ?
        break;

      case "=" :  // the optional operator
        if (substr(myCurrentCategory,  - 7, 7) == "_OPTION") {
         myExpression ~= this.getOperatorType(strippedToken);
          continue 2; // don"t change the category
        }
        // else ?
        break;

      case "ON" : if (myprevCategory == "CREATE_DEF" || myprevCategory == "TYPE_DEF") {
         myExpression ~= this.getReservedType(strippedToken);
         myCurrentCategory = "TABLE_DEF";
          continue 2;
        }
        // else ?
        break;

      default : switch (myCurrentCategory) {

        case "COLUMN_DEF" : if (upperToken[0] == "(" && substr(upperToken,  - 1) == ")") {
            mycols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
            myresult["on"].baseExpression ~= baseExpression;
            myresult["on"]["sub_tree"] = ["expr_type": expressionType("COLUMN_LIST"),
              "base_expr": strippedToken, "sub_tree": mycols];
          }

         myExpression = [];
          baseExpression = "";
         myCurrentCategory = "CREATE_DEF";
          break;

        case "TABLE_DEF" :  // the table name
         myExpression ~= this.getConstantType(strippedToken);
          // TODO: the base_expr should contain the column-def too
          myresult["on"] = ["expr_type": expressionType("TABLE"), "base_expr": baseExpression,
            "name": strippedToken, "no_quotes": this.revokeQuotation(strippedToken),
            "sub_tree": false];
         myExpression = [];
          baseExpression = "";
         myCurrentCategory = "COLUMN_DEF";
          continue 3;

        case "INDEX_NAME" : myresult["base_expr"] = myresult["name"] = strippedToken;
          myresult["no_quotes"] = this.revokeQuotation(strippedToken);

         myExpression = [];
          baseExpression = "";
         myCurrentCategory = "TYPE_DEF";
          break;

        case "INDEX_PARSER" :  // the parser name
         myExpression ~= this.getConstantType(strippedToken);
          myresult["options"] ~= ["expr_type": expressionType("INDEX_PARSER"),
            "base_expr": baseExpression.strip, "sub_tree": myExpression];
         myExpression = [];
          baseExpression = "";
         myCurrentCategory = "CREATE_DEF";

          break;

        case "INDEX_COMMENT" :  // the index comment
         myExpression ~= this.getConstantType(strippedToken);
          myresult["options"] ~= ["expr_type": expressionType("COMMENT"),
            "base_expr": baseExpression.strip, "sub_tree": myExpression];
         myExpression = [];
          baseExpression = "";
         myCurrentCategory = "CREATE_DEF";

          break;

        case "INDEX_OPTION" :  // the key_block_size
         myExpression ~= this.getConstantType(strippedToken);
          myresult["options"] ~= ["expr_type": expressionType("INDEX_SIZE"),
            "base_expr": baseExpression.strip, "size": upperToken,
            "sub_tree": myExpression];
         myExpression = [];
          baseExpression = "";
         myCurrentCategory = "CREATE_DEF";

          break;

        case "INDEX_TYPE" : case "TYPE_OPTION" :  // BTREE or HASH
         myExpression ~= this.getReservedType(
            strippedToken);
          if (myCurrentCategory == "INDEX_TYPE") {
            myresult["index-type"] = ["expr_type": expressionType("INDEX_TYPE"),
              "base_expr": baseExpression.strip, "using": upperToken,
              "sub_tree": myExpression];
          } else {
            myresult["options"] ~= ["expr_type": expressionType("INDEX_TYPE"),
              "base_expr": baseExpression.strip, "using": upperToken,
              "sub_tree": myExpression];
          }

         myExpression = [];
          baseExpression = "";
         myCurrentCategory = "CREATE_DEF";
          break;

        case "LOCK_OPTION" :  // DEFAULT|NONE|SHARED|EXCLUSIVE
         myExpression ~= this.getReservedType(strippedToken);
          myresult["options"] ~= ["expr_type": expressionType("INDEX_LOCK"),
            "base_expr": baseExpression.strip, "lock": upperToken,
            "sub_tree": myExpression];

         myExpression = [];
          baseExpression = "";
         myCurrentCategory = "CREATE_DEF";
          break;

        case "ALGORITHM_OPTION" :  // DEFAULT|INPLACE|COPY
         myExpression ~= this.getReservedType(strippedToken);
          myresult["options"] ~= ["expr_type": expressionType("INDEX_ALGORITHM"),
            "base_expr": baseExpression.strip, "algorithm": upperToken,
            "sub_tree": myExpression];

         myExpression = [];
          baseExpression = "";
         myCurrentCategory = "CREATE_DEF";

          break;

        default : break;
        }

        break;
      }

      myprevCategory = myCurrentCategory;
     myCurrentCategory = "";
    }

    if (myresult["options"] == []) {
      myresult["options"] = false;
    }
    return myresult;
  }

  protected auto getReservedType(myToken) {
    return ["expr_type": expressionType("RESERVED"), "base_expr": myToken];
  }

  protected auto getConstantType(myToken) {
    return ["expr_type": expressionType("CONSTANT"), "base_expr": myToken];
  }

  protected auto getOperatorType(myToken) {
    return ["expr_type": expressionType("OPERATOR"), "base_expr": myToken];
  }

  protected auto processIndexColumnList(myparsed) {
    auto myProcessor = new IndexColumnListProcessor(this.options);
    return myProcessor.process(myparsed);
  }
}
