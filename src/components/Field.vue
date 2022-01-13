<template>
  <table class="field">
      <tr v-for='(row, index) in field' :key="index">
          <td v-for='(cell, idx) in row' :key="idx">
            <transition name="fade" v-if="cell.canFade">
                <Tetromino v-if="cell.value == 'x'" :color="cell.color" />
            </transition>
            <div v-else>
                <Tetromino v-if="cell.value == 'x'" :color="cell.color" />
            </div>
          </td>
      </tr>
  </table>
</template>

<script>
import Tetromino from './Tetromino.vue'
export default {
 name: 'Field',

 props:{
        field: Array,
    },

 components:{
     Tetromino
 },

 data() {
    return {
        color: 'blue',

    }
  },

 methods:{
 },
}
</script>

<style>

table{
    padding:0px;
    margin:0px;
    border-spacing:0px;
    border-collapse: collapse;
    background-color: white;
}

.field{
    border: 10px solid #C9ADA1;
    min-width:340px;
}

td{
    padding:0px;
    margin:0px;
    border-spacing: 0;
    width: 2rem;
    height: 2rem;
}

@media screen and (max-width: 545px) {
    
    body{
    -webkit-transform: scale(0.67);
       -moz-transform: scale(0.67);
            transform: scale(0.67);
    }    
}

@media screen and (max-width: 373px) {
    
    body{
    -webkit-transform: scale(0.49);
       -moz-transform: scale(0.49);
            transform: scale(0.49);
    height:100%;
    }
}

</style>