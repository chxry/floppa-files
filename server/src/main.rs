use std::{
  io::{Error, Write},
  fs::File,
};
use futures::StreamExt;
use actix_web::{web, App, HttpResponse, HttpServer};
use actix_multipart::Multipart;
use actix_files::Files;
use nanoid::nanoid;

#[actix_web::main]
async fn main() -> Result<(), Error> {
  std::fs::create_dir_all("./files")?;

  HttpServer::new(|| {
    App::new()
      .route("/upload", web::post().to(upload))
      .service(Files::new("/files", "./files"))
      .service(
        Files::new(
          "/",
          if cfg!(debug_assertions) {
            "../web/public"
          } else {
            "./web"
          },
        )
        .index_file("index.html"),
      )
  })
  .bind("0.0.0.0:8080")?
  .run()
  .await?;
  Ok(())
}

async fn upload(mut payload: Multipart) -> Result<HttpResponse, Error> {
  let mut field = payload.next().await.unwrap().unwrap();
  let content_type = field.content_disposition().unwrap();
  let filename = format!(
    "{}.{}",
    nanoid!(14),
    content_type
      .get_filename()
      .unwrap()
      .split(".")
      .last()
      .unwrap()
  );
  let mut file = File::create(format!("./files/{}", filename))?;
  let data = field.next().await.unwrap().unwrap();
  file.write_all(&data)?;
  Ok(HttpResponse::Ok().body(filename))
}
