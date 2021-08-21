<template>
  <div id="app">
    <div class="header">
      <div class="settings">
        <label for="columns">Columns:</label>
        <input
          type="number"
          name="columns"
          v-model="COLS">
        <label for="rows">Rows:</label>
        <input
          type="number"
          name="rows"
          v-model="ROWS">
        <label for="speed">Speed (ms):</label>
        <input
          type="number"
          name="speed"
          v-model="SPEED">
      </div>
      <button
        @click="toggleAutomation()">
        {{ running ? 'STOP' : 'START'}}
      </button>
      <button
        @click="generateGrid()">
        Generate grid
      </button>
      <button
        @click="deleteGrid()">
        Delete grid
      </button>
      <div>Status: {{ this.running }}</div>
    </div>
    <div
      class="grid"
      :style="{
        'grid-template-columns': `repeat(${COLS}, 15px)`,
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
      COLS: 20,
      ROWS: 20,
      operations: [
        [0, 1],
        [0, -1],
        [1, -1],
        [-1, 1],
        [1, 1],
        [-1, -1],
        [1, 0],
        [-1, 0]
      ],
      SPEED: 500
    }
  },
  methods: {
    toggleAutomation () {
      if (this.grid.length) {
        this.running = !this.running
        this.simulate()
      }
    },
    simulate () {
      if (this.running) {
        const newGrid = [...this.grid]

        for (let i = 0; i < this.ROWS; i++) {
          for (let j = 0; j < this.COLS; j++) {
            let neighbours = 0
            this.operations.forEach(([x, y]) => {
              const ii = i + x // new row index
              const jj = j + y // new column index

              if (ii >= 0 && ii < this.ROWS && jj >= 0 && jj < this.COLS) {
                neighbours += this.grid[ii][jj]
              }
            })

            if (neighbours < 2 || neighbours > 3) {
              newGrid[i][j] = 0
            } else if (this.grid[i][j] === 0 && neighbours === 3) {
              newGrid[i][j] = 1
            }
          }
        }
        this.grid = newGrid
        setTimeout(this.simulate, this.SPEED)
      }
    },
    deleteGrid () {
      this.grid = []
      this.COLS = 20
      this.ROWS = 20
      this.SPEED = 500
    },
    toggleCellColour (row, col) {
      const newGrid = [...this.grid]
      newGrid[row][col] = this.grid[row][col] ? 0 : 1
      this.grid = newGrid
    },
    generateGrid () {
      this.grid = []

      for (let i = 0; i < this.ROWS; i++) {
        this.grid[i] = []
        for (let j = 0; j < this.COLS; j++) {
          this.grid[i][j] = 0
        }
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

.settings {
  display: flex;
  flex-direction: column;
  margin-bottom: 1rem;
}

input {
  width: 50px;
}

label {
  float: right;
}

.cell {
  text-align: center;
  width: 15px;
  height: 15px;
  border: 1px solid black;
  cursor: pointer;
}
</style>
