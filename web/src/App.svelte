<script lang="ts">
  let uploaded = [];
  let img = Math.floor(Math.random() * 4) + 1;

  let fileUploadHandler = async (e) => {
    let file = e.target.files[0];
    let formData = new FormData();
    formData.append(file.name, file);

    let response = await fetch("/upload", {
      method: "POST",
      body: formData,
    });

    uploaded = [...uploaded, await response.text()];
  };
</script>

<main>
  <header>Floppa Files</header>
  <div class="fileUpload">
    <input type="file" on:change={fileUploadHandler} />
    <h2>Drag or click here to upload</h2>
  </div>
  {#each uploaded as file}
    <p>Uploaded {file}</p>
  {/each}
  <img class="floppa" src="/assets/{img}.png" alt="" />
</main>
