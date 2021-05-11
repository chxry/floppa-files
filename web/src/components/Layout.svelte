<script lang="ts">
  import "../scss/layout.scss";
  import { link } from "svelte-spa-router";

  let img = Math.floor(Math.random() * 4) + 1;
</script>

<main>
  <header>Floppa Files</header>
  <div class="nav">
    <a href="/" use:link>Upload</a>
    <a href="/faq" use:link>FAQ</a>
    <a href="https://github.com/chxry/floppa-files" target="_blank">Source</a>
  </div>
  <div class="content">
    <slot />
  </div>
  <img class="floppa" src="/assets/{img}.png" alt="" />
</main>
