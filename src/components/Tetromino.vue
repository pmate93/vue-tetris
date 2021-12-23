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

.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}


</style>