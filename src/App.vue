<template>
  <div id="app">
    <h1>Cellular Automata in Vue.js 2</h1>
    <div
      class="grid"
      :style="{
        'grid-template-columns': `repeat(${SIZE}, 6px)`,
        'grid-template-rows': `repeat(${SIZE}, 6px)`,
        }">
      <div
        v-for="(row, rowIndex) in grid"
        :key="`row-${rowIndex}`"
        class="row">
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
          :disabled="!ready"
          @click="toggleAutomation()">
          {{ running ? 'STOP' : 'START'}}
        </button>
        <button
          :disabled="running"
          @click="seedGrid()">
          Seed grid
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
      COLS: 40,
      ROWS: 40,
      /**
       * All possible positions of cell's neighbours
       * |o|o|o|
       * |o|x|o|
       * |o|o|o|
       */
      operations: [
        // top row
        [-1, -1],
        [-1, 0],
        [-1, 1],
        // middle row
        [0, -1],
        // [0, 0] - this is the position of out cell
        [0, 1],
        // bottom row
        [1, -1],
        [1, 0],
        [1, 1]
      ],
      SPEED: 200,
      SIZE: 40,
      ready: false,
      generation: 0
    }
  },
  mounted () {
    this.seedGrid()
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
      this.seedGrid()
    },
    checkForLiveCells () {
      for (let i = 0; i < this.grid.length; i++) {
        const row = this.grid[i]
        if (row.some(col => col)) {
          this.ready = true
          break
        } else {
          this.ready = false
        }
      }
    },
    simulate () {
      if (this.running) {
        const newGrid = this.grid.map(row => [...row]) // shallow clone, works in this case

        for (let row = 0; row < this.ROWS; row++) {
          for (let col = 0; col < this.COLS; col++) {
            let neighbours = 0

            for (let k = 0; k < this.operations.length; k++) {
              const [x, y] = this.operations[k]
              const newRow = row + x
              const newCol = col + y

              if (newRow >= 0 && newRow < this.ROWS && newCol >= 0 && newCol < this.COLS) {
                neighbours += this.grid[newRow][newCol]
              }
            }

            if (neighbours < 2 || neighbours > 3) {
              newGrid[row][col] = 0
            } else if (!this.grid[row][col] && neighbours === 3) {
              newGrid[row][col] = 1
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

      if (!this.running) {
        this.generation = 0
        this.grid = this.generateGrid(false)
      }
    },
    toggleCell (row, col) {
      if (!this.running) {
        const newGrid = [...this.grid]
        newGrid[row][col] = this.grid[row][col] ? 0 : 1
        this.grid = newGrid
      }

      this.checkForLiveCells()
    },
    randomNumber () {
      return Math.floor(Math.random() * 2)
    },
    generateGrid (fill = true) {
      const grid = []

      for (let row = 0; row < this.ROWS; row++) {
        grid[row] = []
        for (let col = 0; col < this.COLS; col++) {
          grid[row][col] = fill ? this.randomNumber() : 0
        }
      }

      return grid
    },
    seedGrid () {
      if (!this.running) {
        this.generation = 0
        this.grid = this.generateGrid()
        this.ready = true
      }
    }
  }
}
</script>

<style>
html, body {
  margin: 0;
  height: 100%;
  background-color: lightgoldenrodyellow;
  font-size: 14px;
  font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
}

#app {
  height: 100%;
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
  width: 100%;
  height: 100%;
  background-color: rgb(255, 255, 255);
  cursor: pointer;
}
</style>
