<script lang="ts">
  import "../scss/questionanswer.scss";

  export let question: string;
  export let answer: string;
</script>

<div class="questionAnswer">
  <h2>{question}</h2>
  <p>{answer}</p>
</div>
