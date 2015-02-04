//
//  CardViewCell.m
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import "CardViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CardViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCardInfo:(XECardInfo *)cardInfo{
    _cardInfo = cardInfo;
    if (![cardInfo.img isEqual:[NSNull null]]) {
        [_cardImageView sd_setImageWithURL:[NSURL URLWithString:cardInfo.img] placeholderImage:[UIImage imageNamed:@"topic_load_icon"]];
    }else{
        [_cardImageView sd_setImageWithURL:nil];
        [_cardImageView setImage:[UIImage imageNamed:@"topic_load_icon"]];
    }
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",cardInfo.price];
    _cardTitleLabel.text = cardInfo.title;
    if (cardInfo.status == 1) {
        [_statusBtn setTitle:@"免费领取" forState:UIControlStateNormal];
        _statusBtn.enabled = YES;
        [_statusBtn setBackgroundImage:[UIImage imageNamed:@"card_status_bg"] forState:UIControlStateNormal];
    }else if (cardInfo.status == 2) {
        [_statusBtn setTitle:@"领用完" forState:UIControlStateNormal];
        _statusBtn.enabled = NO;
        [_statusBtn setBackgroundImage:[UIImage imageNamed:@"card_staus_hover_bg"] forState:UIControlStateNormal];
    }else if (cardInfo.status == 3) {
        [_statusBtn setTitle:@"已过期" forState:UIControlStateNormal];
        _statusBtn.enabled = NO;
        [_statusBtn setBackgroundImage:[UIImage imageNamed:@"card_staus_hover_bg"] forState:UIControlStateNormal];
    }else if (cardInfo.status == 4) {
        [_statusBtn setTitle:@"已领取" forState:UIControlStateNormal];
        _statusBtn.enabled = NO;
        [_statusBtn setBackgroundImage:[UIImage imageNamed:@"card_staus_hover_bg"] forState:UIControlStateNormal];
    }
    _cardDes.text = cardInfo.des;
}

- (IBAction)receiveAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didTouchCellWithCardInfo:)]) {
        [_delegate didTouchCellWithCardInfo:_cardInfo];
    }
}

@end
