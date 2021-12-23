<template>
  <Keypresses @rightOrLeft_OneMore="rightOrLeft_OneMore" />
  <Field :field="field" @click="dropOneMore"/>


  <button v-on:click="show = !show">
    Toggle
  </button>
  <transition name="fade">
    <p v-if="show">hello</p>
  </transition>
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
      show: true
    }
  },

  methods:{

    rightOrLeft_OneMore(direction){
      let lastValues = [];
      let canDropMore = true;
      console.log(direction)

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
      console.log(canDropMore);

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
      for (let i = 0; i < this.field.length; i++) {
        for (let j = 0; j < this.field[i].length; j++) {
          if(this.field[i][j].value == '-') break;
          if(j == this.field[i].length -1 && this.field[i][j].value == 'x'){
            for (let k = 0; k < this.field[i].length; k++) {
              this.field[i][k].value = '-';
              
            }
          }
        }
      }
    },

    startGame(){
      let printDelayed = setInterval(() => {

        if (!this.dropOneMore()) {
          clearInterval(printDelayed); // this stops the loop
          this.checkLines();
          this.generateTetromino();
          this.startGame();
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
      let num = Math.floor(Math.random() * 6);

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

  logKey(){
    console.log('dwq')
  },

  mounted(){
    window.addEventListener('keypress', this.logKey);
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


