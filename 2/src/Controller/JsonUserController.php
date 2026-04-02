<?php

namespace App\Controller;

use App\Entity\User;
use App\Form\UserType;
use App\Repository\UserRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;

#[Route('/api/user')]
final class JsonUserController extends AbstractController
{
	#[Route(name: 'app_json_user_index', methods: ['GET'], format: 'json')]
	public function index(UserRepository $userRepository): Response
	{
		return $this->json($userRepository->findAll());
	}

	#[Route(name: 'app_json_user_new', methods: ['POST'], format: 'json')]
	public function new(Request $request, EntityManagerInterface $entityManager, SerializerInterface $serializer, ValidatorInterface $validator): Response
	{
		if ('json' !== $request->getContentTypeFormat()) {
			return $this->json(['message' => 'Unsupported content format'], 400);
		}

		$jsonData = $request->getContent();
		$user = $serializer->deserialize($jsonData, User::class, 'json');
		
		$errors = $validator->validate($user);
		if (count($errors) > 0) {
			return $this->json(['message' => (string) $errors], 400);
		}
		
		$entityManager->persist($user);
		$entityManager->flush();
		
		return $this->json($user, status: Response::HTTP_CREATED);
	}

	#[Route('/{id}', name: 'app_json_user_show', methods: ['GET'], format: 'json')]
	public function show(User $user): Response
	{
		return $this->json($user);
	}

	#[Route('/{id}', name: 'app_json_user_edit', methods: ['PATCH', 'PUT'], format: 'json')]
	public function edit(Request $request, User $user, EntityManagerInterface $entityManager, SerializerInterface $serializer, ValidatorInterface $validator): Response
	{
		if ('json' !== $request->getContentTypeFormat()) {
			return $this->json(['message' => 'Unsupported content format'], 400);
		}

		$jsonData = $request->getContent();
		$userMod = $serializer->deserialize($jsonData, User::class, 'json');
		
		$errors = $validator->validate($userMod);
		if (count($errors) > 0) {
			return $this->json(['message' => (string) $errors], 400);
		}
		
		if ($request->getMethod() === 'PUT') {
			$diff = array_diff($entityManager->getClassMetadata(User::class)->getFieldNames(), array_keys(json_decode($jsonData, true)));
			$diff = array_diff($diff, array('id'));
			if (count($diff) > 0) {
				return $this->json(['message' => "Missing fields", 'missing_fields' => array_values($diff)], 400);
			}
		}
		
		$serializer->deserialize($jsonData, user::class, 'json', ['object_to_populate' => $user]);
		$entityManager->flush();
		
		return $this->json($user);
	}

	#[Route('/{id}', name: 'app_json_user_delete', methods: ['DELETE'], format: 'json')]
	public function delete(Request $request, User $user, EntityManagerInterface $entityManager): Response
	{
		$entityManager->remove($user);
		$entityManager->flush();

		return $this->json(null, Response::HTTP_NO_CONTENT);
	}
}
