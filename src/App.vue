<template>
  <div id="app">
    <div class="header">
      <button
        @click="toggleAutomation()">
        {{ running ? 'stop' : 'start'}}
      </button>
      <button
        @click="generateGrid()">
        generate grid
      </button>
      <button
        @click="clearGrid()">
        clear grid
      </button>
      <div>Status: {{ this.running }}</div>
    </div>
    <div
      class="grid"
      :style="{
        'grid-template-columns': `repeat(${COLS}, ${cellHeight}px)`,
        }">
      <div
        v-for="(row, rowIndex) in grid"
        :key="`row-${rowIndex}`">
        <div
          v-for="(cell, collIndex) in row"
          :key="`cell-${collIndex}`"
          class="cell"
          :style="{
            'background-color': grid[rowIndex][collIndex]
              ? 'black'
              : 'yellow',
            'color': grid[rowIndex][collIndex]
              ? 'white'
              : 'black'
          }"
          @click="toggleCellColour(rowIndex, collIndex)">
          {{ grid[rowIndex][collIndex] }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App',
  data () {
    return {
      running: false,
      grid: [],
      cellWidth: 20,
      cellHeight: 20,
      COLS: 10,
      ROWS: 10
    }
  },
  methods: {
    toggleAutomation () {
      this.running = !this.running
    },
    clearGrid () {
      this.grid = []
    },
    toggleCellColour (row, col) {
      const newGrid = [...this.grid]
      newGrid[row][col] = newGrid[row][col] ? 0 : 1
      this.grid = newGrid
    },
    generateGrid () {
      this.grid = []

      for (let i = 0; i < this.ROWS; i++) {
        this.grid.push(Array.from(Array(this.COLS), () => 0))
      }
    }
  }
}
</script>

<style>
html, body {
  background-color: lightgoldenrodyellow;
}

.grid {
  display: grid;
}

.cell {
  text-align: center;
  width: 20px;
  height: 20px;
  border: 1px solid black;
  cursor: pointer;
}
</style>
