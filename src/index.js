import { Elm } from "./Main.elm"
import confetti from "canvas-confetti"

const app = Elm.Main.init({
  node: document.getElementById("elm-root"),
})

app.ports.confetti.subscribe(() => {
  confetti({
    particleCount: 100,
    spread: 70,
    origin: { y: 0.6 },
  })
})
