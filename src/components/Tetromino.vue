<template>
  <img :src="require('../assets/tetrominos/' + color + '.png')" alt="">
</template>

<script>
export default {
    name: 'Tetromino',

    props:{
        color: String,
    }
}
</script>

<style>

img{
    width: 2rem;
    margin:0px;
    display:block;
}


</style>