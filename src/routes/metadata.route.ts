import { Router } from "express";
import { Routes } from "@interfaces/routes.interface";
import validationMiddleware from "@middlewares/validation.middleware";
import multer from "multer";
import GeneratorController from "@/controllers/generatorController";
import { CreateMetadataDto } from "@/dtos/metadata.dto";
const upload = multer({ dest: "uploads/" });

class GeneratorRoute implements Routes {
  public path = "/metadata";
  public router = Router();
  public generatorController = new GeneratorController();

  constructor() {
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.post(
      `${this.path}`,
      validationMiddleware(CreateMetadataDto, "body"),
      this.generatorController.generateMetadata,
    );
  }
}

export default GeneratorRoute;
