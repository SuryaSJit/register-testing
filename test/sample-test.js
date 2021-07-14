const { expect } = require("chai");

describe("Register", () => {

  let Token, token , User, user , owner, addr1,addr2;

  beforeEach(async () => {
    Token = await ethers.getContractFactory('Token');
    [owner,addr1,addr2] = await ethers.getSigners();
    token = await Token.deploy();
    User = await ethers.getContractFactory('UserRegister');
    user = await User.deploy(token.address);
  });

  describe('Deployment', () => {
    it('Should set the right owner', async function () {
      expect(await token.owner()).to.equal(owner.address);
    });

    it('Should assign the total supply of tokens to the owner', async () => {
      const ownerBalance = await token.balanceOf(owner.address);
      expect(await token.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe('Token Transfer', ()=>{
    it('Should transfer tokens to accounts', async () =>{
      await token.transfer(addr1.address,500);
      const addr1Balance = await token.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(500);

      await token.transfer(addr2.address,500);
      const addr2Balance = await token.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(500);
    })
  })



  describe('Transactions',()=>{
    it('Should transfer tokens to contract',async ()=>{



      const amount = 100;
      await token.transfer(addr1.address,500);
      const addr1Balance = await token.balanceOf(addr1.address);
      console.log(Number(addr1Balance));
      expect(addr1Balance).to.equal(500);

      
      await token.transfer(addr2.address,500);
      const addr2Balance = await token.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(500);

      await token.connect(addr1).approve(user.address,amount);
      await user.connect(addr1).register(owner.address);
     

      await token.connect(addr2).approve(user.address,100);
      await user.connect(addr2).register(addr1.address);


      expect((await user.user(addr1.address)).referralCode).to.be.eq(owner.address);
      expect((await user.user(addr2.address)).referralCode).to.be.eq(addr1.address);

    });
    


    it('Register: Fail', async () => {

      const amount = 100;
      await token.transfer(addr1.address,500);
      const addr1Balance = await token.balanceOf(addr1.address);
      console.log("Account balance :",Number(addr1Balance));
      expect(addr1Balance).to.equal(500);

      await token.transfer(addr2.address,500);
      const addr2Balance = await token.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(500);
 
      await token.connect(addr1).approve(user.address, amount);
      await user.connect(addr1).register(owner.address);
      await expect(user.connect(addr1).register(owner.address)).to.be.revertedWith('User already registered');

      await token.connect(addr2).approve(user.address,amount);
      await user.connect(addr2).register(addr1.address);
      await expect(user.connect(addr2).register(addr1.address)).to.be.revertedWith('User already registered');
   
    });

    it('Set Score', async () =>{
      const amount1 = 100;
      await token.transfer(addr1.address,500);
      const addr1Balance = await token.balanceOf(addr1.address);
      console.log("Account balance :",Number(addr1Balance));
      expect(addr1Balance).to.equal(500);
      await token.connect(addr1).approve(user.address, amount1);
      await user.connect(addr1).register(owner.address);
      await expect(user.connect(addr1).register(owner.address)).to.be.revertedWith('User already registered');
      const score = 400;
      await user.connect(owner).setScore(addr1.address,score);
      // await user.connect(owner).setScore(addr1.address,score);
      // await user.connect(owner).setScore(addr1.address,score);

      // await expect(user.connect(owner).setScore(addr1.address,score)).to.be.revertedWith('User address not registered');



    })
  })


});
