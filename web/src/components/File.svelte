<script lang="ts">
  import "../scss/file.scss";
  import type { FileUpload } from "../main";
  export let file: FileUpload;

  let urlElement: Node;

  let copyHandler = () => {
    let selection = document.getSelection();
    var range = document.createRange();
    range.selectNode(urlElement);
    selection.removeAllRanges();
    selection.addRange(range);
    document.execCommand("copy");
  };
</script>

<div class="file">
  <p>
    {file.url ? "Uploaded" : "Uploading"}
    <span class="fileName">{file.name}</span>
  </p>
  {#if file.url}
    <img
      class="copyButton"
      on:click={copyHandler}
      src="/assets/copy.svg"
      alt="copy"
    />
    <a href={file.url} bind:this={urlElement}>{file.url.split("//").pop()}</a>
  {/if}
</div>
