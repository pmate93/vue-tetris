<template>
  <Keypress key-event="keydown" :key-code="39" @success="$emit('rightOrLeft_OneMore', 'right')" />
  <Keypress key-event="keydown" :key-code="37" @success="$emit('rightOrLeft_OneMore', 'left')" />
  <Keypress key-event="keydown" :key-code="38" @success="$emit('turnTetromino')" />
  <Keypress key-event="keydown" :key-code="40" @success="$emit('dropOneMore', true)" />
</template>

<script>
import { defineAsyncComponent } from 'vue'

export default {
    
    components:{
        Keypress: defineAsyncComponent(() => import("vue-keypress"))
    },

    emits:['rightOrLeft_OneMore', 'turnTetromino', 'dropOneMore']

}
</script>

<style>

</style>