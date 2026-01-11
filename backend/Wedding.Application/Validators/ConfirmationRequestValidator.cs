using FluentValidation;
using Wedding.Application.DTOs;

namespace Wedding.Application.Validators
{
    public class ConfirmationRequestValidator : AbstractValidator<ConfirmationRequest>
    {
        public ConfirmationRequestValidator()
        {
            RuleFor(x => x.Guests).NotEmpty().WithMessage("La lista de invitados no puede estar vacía.");
            RuleForEach(x => x.Guests).SetValidator(new GuestConfirmationValidator());
        }
    }

    public class GuestConfirmationValidator : AbstractValidator<GuestConfirmationDto>
    {
        public GuestConfirmationValidator()
        {
            RuleFor(x => x.GuestId).NotEmpty();
            RuleFor(x => x.FunnyComment).MaximumLength(500).WithMessage("El comentario gracioso no puede exceder los 500 caracteres.");
        }
    }
}
