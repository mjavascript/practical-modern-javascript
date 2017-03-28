import counter, { increment, decrement as remove } from './counter.js'

increment()
console.log(counter) // <- 1

increment()
console.log(counter) // <- 2

remove()
console.log(counter) // <- 1
