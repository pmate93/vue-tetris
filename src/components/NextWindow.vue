<template>
    <div class="next">
        next
        <div class="tables-container">
            <table class="next-table" v-for='(each, index) in nextTetrominos' :key="index">
                <tr v-for='(row, idx) in each.blocksForNext' :key="idx">
                    <td v-for='(cell, idx) in row' :key="idx">
                        <Tetromino v-if="cell == 'x'" :color="each.color" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</template>

<script>
import Tetromino from './Tetromino.vue';

export default {
    name: 'NextWindow',

    components:{
        Tetromino
    },

    props:{
        nextTetrominos: Array,
    },
}
</script>

<style>

.tables-container{
    margin-top: 10%;
    padding-top: 4%;
    padding-bottom: 2%;
    background-color: azure;
    border-radius: 5px;
    height: 300px;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
}

.next-table{
    margin: 10% auto;
}

.next-table td{
    background-color: azure;
}

.next{
  font-family: "Copperplate Gothic Light";
  font-size: 2rem;
  text-align: center;
  padding: 20px;
  min-width: 10rem;
}

</style>