import { Router } from 'express';
import { CreateUserDto } from '@dtos/users.dto';
import { Routes } from '@interfaces/routes.interface';
import validationMiddleware from '@middlewares/validation.middleware';
import multer from 'multer';
import GeneratorController from '@/controllers/generatorController';
const upload = multer({ dest: 'uploads/' });

class GeneratorRoute implements Routes {
  public path = '/metadata';
  public router = Router();
  public generatorController = new GeneratorController();

  constructor() {
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.get(`${this.path}`, this.generatorController.generateMetadata);
  }
}

export default GeneratorRoute;
