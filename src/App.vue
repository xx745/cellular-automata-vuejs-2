<template>
  <div id="app">
    <h1>Cellular Automata in Vue.js 2</h1>
    <div
      class="grid"
      :style="{
        'grid-template-columns': `repeat(${COLS}, 11px)`,
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
              ? 'rgb(80, 80, 80)'
              : 'rgb(255, 208, 190)'
          }"
          @click="toggleCell(rowIndex, collIndex)">
        </div>
      </div>
    </div>
    <div class="controls">
      <div class="settings">
        <div for="speed">Speed (ms):</div>
        <input
          type="radio"
          id="speed-200"
          value="200"
          v-model="SPEED"
          :disabled="running">
        <label
          class="speed"
          for="speed-200">200</label>
        <input
          type="radio"
          id="speed-500"
          value="500"
          v-model="SPEED"
          :disabled="running">
        <label
          class="speed"
          for="speed-500">500</label>
        <input
          type="radio"
          id="speed-1000"
          value="1000"
          v-model="SPEED"
          :disabled="running">
        <label
          class="speed"
          for="speed-1000">1000</label>
      </div>

      <div class="settings">
        <label
          class="size"
          for="size">Size:</label>
        <input
          type="number"
          id="size"
          v-model="SIZE"
          :disabled="running"
          @change="updateSize()">
      </div>

      <div class="buttons">
        <button
          :class="running ? 'stop' : 'start'"
          @click="toggleAutomation()">
          {{ running ? 'STOP' : 'START'}}
        </button>
        <button
          :disabled="running"
          @click="generateGrid()">
          Generate grid
        </button>
        <button
          :disabled="running"
          @click="emptyGrid()">
          Empty grid
        </button>
      </div>

      <div>Status: {{ running ? 'running...' : 'stopped!' }}</div>
      <div>Generation: {{ generation }}</div>
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
      SPEED: 200,
      SIZE: 20,
      ready: false,
      generation: 0
    }
  },
  mounted () {
    this.generateGrid()
  },
  methods: {
    toggleAutomation () {
      if (this.grid.length && this.ready) {
        this.running = !this.running
        this.simulate()
      }
    },
    updateSize () {
      this.COLS = this.SIZE
      this.ROWS = this.SIZE
      this.generateGrid()
    },
    checkForLiveCells () {
      this.grid.forEach(row => {
        row.forEach(cell => {
          if (cell === 1) {
            this.ready = true
          }
        })
      })
    },
    simulate () {
      if (this.running) {
        const newGrid = [...this.grid]

        for (let i = 0; i < this.ROWS; i++) {
          for (let j = 0; j < this.COLS; j++) {
            let neighbours = 0

            for (let k = 0; k < this.operations.length; k++) {
              const [x, y] = this.operations[k]
              const newI = i + x
              const newJ = j + y

              if (newI >= 0 && newI < this.ROWS && newJ >= 0 && newJ < this.COLS) {
                neighbours += this.grid[newI][newJ]
              }
            }

            if (neighbours < 2 || neighbours > 3) {
              newGrid[i][j] = 0
            } else if (this.grid[i][j] === 0 && neighbours === 3) {
              newGrid[i][j] = 1
            }
          }
        }

        this.grid = newGrid
        this.generation += 1

        setTimeout(this.simulate, this.SPEED)
      }
    },
    emptyGrid () {
      this.ready = false
      this.generation = 0

      if (!this.running) {
        this.grid = []
        for (let i = 0; i < this.ROWS; i++) {
          this.grid[i] = []
          for (let j = 0; j < this.COLS; j++) {
            this.grid[i][j] = 0
          }
        }
      }
    },
    toggleCell (row, col) {
      if (!this.running) {
        const newGrid = [...this.grid]
        newGrid[row][col] = this.grid[row][col] ? 0 : 1
        this.grid = newGrid
        this.checkForLiveCells()
      }
    },
    generateGrid () {
      this.generation = 0

      if (!this.running) {
        this.grid = []
        for (let i = 0; i < this.ROWS; i++) {
          this.grid[i] = []
          for (let j = 0; j < this.COLS; j++) {
            this.grid[i][j] = Math.floor(Math.random() * 2)
          }
        }
      }

      this.ready = true
    }
  }
}
</script>

<style>
html, body {
  background-color: lightgoldenrodyellow;
  font-size: 14px;
  font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
}

#app {
  display: flex;
  flex-direction: column;
  align-items: center;
}

h1 {
  margin: 0.5rem
}

.grid {
  display: grid;
  margin-bottom: 0.5rem;
}

.settings {
  margin-bottom: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
}

.settings > div {
  margin-right: 1rem;
}

.buttons {
  display: flex;
  justify-content: space-around;
}

input {
  margin-left: 1rem;
}

input#size {
  width: 5rem;
  padding: 0.25rem;
}

button {
  margin: 1rem;
  cursor: pointer;
  padding: 0.5rem;
  border-radius: 4px;
  border-style: none;
  box-shadow: rgba(0, 0, 0, 0.25) 0px 3px 8px;
  background-color: rgb(243, 217, 67);
}

button:hover, button:focus, button:active {
  box-shadow: rgba(0, 0, 0, 0.50) 0px 3px 8px;
  position: relative;
  bottom: 2px;
}

.start {
  width: 4rem;
  background-color: rgb(67, 196, 77);
  font-weight: bold;
}

.stop {
  width: 4rem;
  background-color: rgb(199, 60, 60);
  font-weight: bold;
  color: white;
}

.cell {
  text-align: center;
  width: 10px;
  height: 10px;
  border: 1px solid rgb(80, 80, 80);
  cursor: pointer;
}
</style>
