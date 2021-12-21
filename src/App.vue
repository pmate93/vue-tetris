<template>
  <Field :field="field" @click="dropOneMore"/>
</template>

<script>
import Field from './components/Field.vue';

const rows = 20;
const cols = 10;

export default {
  name: 'App',
  components: {
    Field,  
  },

  data() {
    return {
      field: [],
    }
  },

  methods:{

    startGame(){
      //let idx = 0;
      let printDelayed = setInterval(() => {
        
        //idx++;

        if (!this.dropOneMore()) {
          clearInterval(printDelayed); // this stops the loop
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
            i + 1 > rows - 1 ? canDropMore = false : null; 
          }
        }
      }
      console.log(canDropMore)

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
          }
        }
      }
    },
    

    generateField(){
      let id = 0;

      for (let i = 0; i < rows; i++) {
        this.field.push( [] );
        for (let j = 0; j < cols; j++) {
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
      console.log(this.field);
    }
  },

  created(){
    this.generateField();
    this.generateTetromino();
    this.startGame();
  }
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
</style>


