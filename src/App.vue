<template>
  <Keypresses 
    @rightOrLeft_OneMore="rightOrLeft_OneMore"
    @turnTetromino="turnTetromino"
  />
  <Field :field="field" @click="dropOneMore"/>

</template>

<script>
import Field from './components/Field.vue';
import Keypresses from './components/Keypresses.vue';

const ROWS = 20;
const COLS = 10;

export default {
  name: 'App',
  components: {
    Field,
    Keypresses
  },

  data() {
    return {
      field: [],
      tetrominoType: 0,
      canTryToTurnOrMove: true

    }
  },

  methods:{

    turnTetromino(){

      if(!this.canTryToTurnOrMove) return;

      let lastValues = [];

      for (let i = 0; i < this.field.length; i++) {
        for (let j = 0; j < this.field[i].length; j++) {
          if(this.field[i][j].value == 'x' && this.field[i][j].isActive){
            lastValues.push({
              i: i,
              j: j
            });
          }
        }
      }

      let maxRight = 0;
      let minLeft = lastValues[0].j;
      let top = lastValues[0].i;
      let bottom = 0;

      for (let i = 0; i < lastValues.length; i++) {
        if(lastValues[i].j > maxRight){
          maxRight = lastValues[i].j;
        }
        if(lastValues[i].j < minLeft){
          minLeft = lastValues[i].j;
        }
        if(lastValues[i].i < top){
          top = lastValues[i].i;
        }
        if(lastValues[i].i > bottom){
          bottom = lastValues[i].i;
        }
      }

      let rowLength = maxRight - minLeft;
      let colLength = bottom - top;

      let rowToAdd = 0;
      let colToAdd = 0;
      if(colLength-rowLength < 0){
        rowToAdd = colLength-rowLength;
      }
      else if(colLength-rowLength > 0){
        colToAdd = colLength-rowLength;
      }

      for (let i = 0; i < this.field.length; i++) {
        for (let j = 0; j < this.field[i].length; j++) {
          if(this.field[i][j].value == 'x' && this.field[i][j].isActive){
            this.field[i][j].value = '-';
            this.field[i][j].isActive = false;
          }
        }
      }



      //forgatás
      let index = 0;
      let i_from_0 = 0;
      let j_from_0 = 0;
      let correction_j = top;
      let correction_i = minLeft;

      let pushToRight = 0;
      let pushToTop = 0;

      //kell e tolni
      for (let i = top + rowToAdd; i <= bottom; i++) {
        j_from_0 = 0;
        for (let j = minLeft; j <= maxRight + colToAdd; j++) {
          //console.log(this.field[i][j], i_from_0, j_from_0, i, j);
          if(i == lastValues[index].i && j == lastValues[index].j){
            if(0 > correction_i + (rowLength - i_from_0)){
              pushToRight = -(correction_i + (rowLength - i_from_0));
            }
            if(correction_j + j_from_0 >= ROWS){
              pushToTop--;
            }
            index < lastValues.length - 1 ? index++ : null;
          }
          j_from_0++;
        }
        i_from_0++;
      }

      if((this.tetrominoType === 0 || this.tetrominoType === 1 || this.tetrominoType === 2) && rowLength === 2){
          pushToRight++;
        }
        else if(this.tetrominoType === 4 && rowLength === 3){
          pushToRight += 3;
        }
        else if(this.tetrominoType >= 5 && rowLength === 1 && maxRight != COLS - 1){
          console.log("maxright", maxRight)
          pushToRight++;
        }

      //nincs e oldalt semmi
      index = 0;
      i_from_0 = 0;
      let canTurn = true;
      for (let i = top + rowToAdd; i <= bottom; i++) {
        j_from_0 = 0;
        for (let j = minLeft; j <= maxRight + colToAdd; j++) {
          //console.log(this.field[i][j], i_from_0, j_from_0, i, j);
          if(i == lastValues[index].i && j == lastValues[index].j){
            if(pushToTop + correction_j + j_from_0 > ROWS || pushToRight + correction_i + (rowLength - i_from_0) > COLS){
              canTurn = false;
            }
            else if(this.field[pushToTop + correction_j + j_from_0][pushToRight + correction_i + (rowLength - i_from_0)].value == 'x'){
              canTurn = false;
            }
            index < lastValues.length - 1 ? index++ : null;
          }
          j_from_0++;
        }
        i_from_0++;
      }

      if(canTurn){
  
        index = 0;
        i_from_0 = 0;
        for (let i = top + rowToAdd; i <= bottom; i++) {
          j_from_0 = 0;
          for (let j = minLeft; j <= maxRight + colToAdd; j++) {
            //console.log(this.field[i][j], i_from_0, j_from_0, i, j);
            if(i == lastValues[index].i && j == lastValues[index].j){
              this.field[pushToTop + correction_j + j_from_0][pushToRight + correction_i + (rowLength - i_from_0)].value = 'x';
              this.field[pushToTop + correction_j + j_from_0][pushToRight + correction_i + (rowLength - i_from_0)].isActive = true;
              index < lastValues.length - 1 ? index++ : null;
            }
            j_from_0++;
          }
          i_from_0++;
          
        }
      }else{
        for (let i = 0; i < lastValues.length; i++) {
          this.field[lastValues[i].i][lastValues[i].j].value = 'x';
          this.field[lastValues[i].i][lastValues[i].j].isActive = true;
          
        }
      }

      

    },

    rightOrLeft_OneMore(direction){
      
      if(!this.canTryToTurnOrMove) return;
      let lastValues = [];
      let canDropMore = true;

      for (let i = 0; i < this.field.length; i++) {
        for (let j = 0; j < this.field[i].length; j++) {
          if(this.field[i][j].value == 'x' && this.field[i][j].isActive){
            lastValues.push({
              i: i,
              j: j
            });
          }
        }
      }

      //maxkeres jobb oldalon
      let maxIdxRight = 0;
      let maxRight = 0;
      let minLeft = lastValues[0].j;
      let minIdxLeft = 0;

      for (let i = 0; i < lastValues.length; i++) {
        if(lastValues[i].j > maxRight){
          maxRight = lastValues[i].j;
          maxIdxRight = i;
        }
        if(lastValues[i].j < minLeft){
          minLeft = lastValues[i].j;
          minIdxLeft = i;
        }
      }
      

      if(lastValues[maxIdxRight].j + 1 > COLS - 1 && direction == "right" || lastValues[minIdxLeft].j == 0 && direction == "left"){
        canDropMore = false;
      }else{
        for (let i = 0; i < lastValues.length; i++) {
          if(direction == "right" && this.field[lastValues[i].i][lastValues[i].j + 1].value == 'x' && !this.field[lastValues[i].i][lastValues[i].j + 1].isActive){
            canDropMore = false;
          }

          
          else if(direction == "left" && this.field[lastValues[i].i][lastValues[i].j - 1].value == 'x' && !this.field[lastValues[i].i][lastValues[i].j - 1].isActive){
            canDropMore = false;
          }
        }
      }

      if(canDropMore){

        for (let i = 0; i < this.field.length; i++) {
          for (let j = 0; j < this.field[i].length; j++) {
            if(this.field[i][j].value == 'x' && this.field[i][j].isActive){
              this.field[i][j].value = '-';
              this.field[i][j].isActive = false;
            }
          }
        }
        
        let index = 0;
        for (let i = 0; i < this.field.length; i++) {
          for (let j = 0; j < this.field[i].length; j++) {
            if(lastValues[index].i == i && lastValues[index].j == j && direction == "right"){
              this.field[i][j + 1].value = 'x';
              this.field[i][j + 1].isActive = true;
              index < lastValues.length - 1 ? index++ : null;
            }
            else if(lastValues[index].i == i && lastValues[index].j == j && direction == "left"){
              this.field[i][j - 1].value = 'x';
              this.field[i][j - 1].isActive = true;
              index < lastValues.length - 1 ? index++ : null;
            }
          }
        }
        return true;
      }else{

        return false;
      }


    },

    checkLines(){
      let rowCounter = 0;
      let lastRowCleared = -1;

      for (let i = 0; i < this.field.length; i++) {
        for (let j = 0; j < this.field[i].length; j++) {
          if(this.field[i][j].value == '-') break;
          if(j == this.field[i].length -1 && this.field[i][j].value == 'x'){
            for (let k = 0; k < this.field[i].length; k++) {
              this.field[i][k].value = '-';
              
              
            }
            rowCounter++;
            lastRowCleared = i;
          }
        }
      }

      

      setTimeout(()=>{
        let lastValues = [];
        if(rowCounter > 0){
          for (let i = 0; i <= lastRowCleared; i++) {
            for (let j = 0; j < this.field[i].length; j++) {
              if(this.field[i][j].value == 'x'){
                lastValues.push({
                  i: i,
                  j: j
                });
                this.field[i][j].value = '-';
              }
            }
          }
          let index = 0;
          for (let i = 0; i <= lastRowCleared; i++) {
            for (let j = 0; j < this.field[i].length; j++) {
              if(lastValues[index].i == i && lastValues[index].j == j){
                this.field[lastValues[index].i + rowCounter][j].value = 'x';
                this.field[lastValues[index].i + rowCounter][j].canFade = true;
                index == lastValues.length -1 ? null : index++;
              }
            }
          }

          for (let i = 0; i <= lastRowCleared; i++) {
            for (let j = 0; j < this.field[i].length; j++) {
              if(this.field[i][j].value == '-'){
                this.field[i][j].canFade = false;
              }
            }
          }

        }
      }, 1000)

      if(rowCounter > 0) return true;
      return false;
    },

    startGame(){
      let printDelayed = setInterval(() => {

        if (!this.dropOneMore()) {
          clearInterval(printDelayed); // this stops the loop
          if(this.checkLines()){
            this.canTryToTurnOrMove = false;
            setTimeout(() => {
              this.generateTetromino();
              this.startGame();
            }, 1000);
          }else{
            this.generateTetromino();
            this.startGame();
          }


        }
      }, 1000)
    },

    dropOneMore(){
      let lastValues = [];
      let canDropMore = true;

      for (let i = 0; i < this.field.length; i++) {
        for (let j = 0; j < this.field[i].length; j++) {
          if(this.field[i][j].value == 'x' && this.field[i][j].isActive){
            lastValues.push({
              i: i,
              j: j
            });
          }
        }
      }
      //maxkeres
      let maxIdx = 0;
      let max = 0;
      //console.log(maxIdx)
      for (let i = 0; i < lastValues.length; i++) {
        if(lastValues[i].i > max){
          max = lastValues[i].i;
          maxIdx = i;
        }
      }
      

      if(lastValues[maxIdx].i + 1 > ROWS - 1){
        canDropMore = false;
      }else{
        for (let i = 0; i < lastValues.length; i++) {
          if(!this.field[lastValues[i].i + 1][lastValues[i].j].isActive && this.field[lastValues[i].i + 1][lastValues[i].j].value == 'x'){
            canDropMore = false;
          }
        }
      }


      if(canDropMore){

        for (let i = 0; i < this.field.length; i++) {
          for (let j = 0; j < this.field[i].length; j++) {
            if(this.field[i][j].value == 'x' && this.field[i][j].isActive){
              this.field[i][j].value = '-';
              this.field[i][j].isActive = false;
            }
          }
        }
        
        let index = 0;
        for (let i = 0; i < this.field.length; i++) {
          for (let j = 0; j < this.field[i].length; j++) {
            if(lastValues[index].i == i && lastValues[index].j == j){
              this.field[i + 1][j].value = 'x';
              this.field[i + 1][j].isActive = true;
              index < lastValues.length - 1 ? index++ : null;
            }
          }
        }
        return true;
      }else{

        for (let i = 0; i < lastValues.length; i++) {
          this.field[lastValues[i].i][lastValues[i].j].isActive = false;
          this.field[lastValues[i].i][lastValues[i].j].canFade = true;
        }
        return false;
      }


    },

    generateTetromino(){
      let num = Math.floor(Math.random() * 7);
      this.tetrominoType = num;
      this.canTryToTurnOrMove = true;

      let tetrominos = [
        [
          ['-', 'x', 'x', 'x'],
          ['-', '-', '-', 'x'],
        ],
        [
          ['-', 'x', 'x', 'x'],
          ['-', 'x', '-', '-'],
        ],
        [
          ['-', '-', 'x', '-'],
          ['-', 'x', 'x', 'x'],
        ],
        [
          ['-', '-', 'x', 'x'],
          ['-', '-', 'x', 'x'],
        ],
        [
          ['x', 'x', 'x', 'x'],
          ['-', '-', '-', '-'],
        ],
        [
          ['-', '-', 'x', 'x'],
          ['-', 'x', 'x', '-'],
        ],
        [
          ['-', 'x', 'x', '-'],
          ['-', '-', 'x', 'x'],
        ],
      ];
      
      let startIdx = 2;
      for (let i = 0; i < tetrominos[num].length; i++) {
        for (let j = 0; j < tetrominos[num][i].length; j++) {
          if(tetrominos[num][i][j] == 'x'){
            this.field[i][startIdx + j].value = 'x';
            this.field[i][startIdx + j].isActive = true;
            this.field[i][startIdx + j].canFade = false;
          }
        }
      }
    },
    

    generateField(){
      let id = 0;

      for (let i = 0; i < ROWS; i++) {
        this.field.push( [] );
        for (let j = 0; j < COLS; j++) {
          let cell = {
            value: '-',
            id: id,
            canDrop: false,
            isActive: false,
          }
          this.field[i][j] = cell;
          id++;
        }
      }
      //console.log(this.field);
    }
  },


  created(){
    this.generateField();
    this.generateTetromino();
    this.startGame();
    

    
  },

  

  
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
  display:flex;
  justify-content: center;
  background-color:gray;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
</style>


